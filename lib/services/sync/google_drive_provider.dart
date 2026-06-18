import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'cloud_provider.dart';
import 'google_oauth.dart';

/// Caches an access token and refreshes it via the refresh token as needed.
class GoogleAuthSession {
  GoogleAuthSession({
    required this.clientId,
    required this.clientSecret,
    required this.refreshToken,
    GoogleOAuth? oauth,
  }) : _oauth = oauth ?? GoogleOAuth();

  final String clientId;
  final String clientSecret;
  final String refreshToken;
  final GoogleOAuth _oauth;

  String? _token;
  DateTime? _expiry;

  Future<String> token() async {
    final now = DateTime.now();
    if (_token != null &&
        _expiry != null &&
        now.isBefore(_expiry!.subtract(const Duration(minutes: 1)))) {
      return _token!;
    }
    final fresh = await _oauth.refresh(
      clientId: clientId,
      clientSecret: clientSecret,
      refreshToken: refreshToken,
    );
    _token = fresh.accessToken;
    _expiry = fresh.expiry;
    return _token!;
  }
}

/// [CloudProvider] backed by Google Drive (API v3, `drive.file` scope). All app
/// files live flat inside a dedicated "PaperDoc" folder; the rel path and our
/// SHA-256 content hash are stored in each file's `appProperties` so the
/// reconciler compares hashes in a single space (Drive's own checksum is MD5,
/// which we ignore).
class GoogleDriveProvider implements CloudProvider {
  GoogleDriveProvider(this._auth, {this.rootFolderName = 'PaperDoc', String? rootId})
      : _rootId = rootId;

  final GoogleAuthSession _auth;
  final String rootFolderName;
  String? _rootId;
  final Map<String, String> _idByRelPath = {};

  static const _base = 'https://www.googleapis.com/drive/v3';
  static const _upload = 'https://www.googleapis.com/upload/drive/v3';

  String? get rootId => _rootId;

  @override
  String get name => 'gdrive';

  Future<Map<String, String>> _authHeader() async =>
      {'Authorization': 'Bearer ${await _auth.token()}'};

  @override
  Future<String> ensureRoot() async {
    if (_rootId != null) return _rootId!;
    final query = "mimeType='application/vnd.google-apps.folder' "
        "and name='$rootFolderName' and trashed=false";
    final uri = Uri.parse('$_base/files').replace(queryParameters: {
      'q': query,
      'fields': 'files(id,name)',
      'spaces': 'drive',
    });
    final res = await http.get(uri, headers: await _authHeader());
    if (res.statusCode != 200) {
      throw _err('list root folder', res);
    }
    final files = (jsonDecode(res.body) as Map)['files'] as List;
    if (files.isNotEmpty) {
      return _rootId = (files.first as Map)['id'] as String;
    }
    final created = await http.post(
      Uri.parse('$_base/files?fields=id'),
      headers: {...await _authHeader(), 'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': rootFolderName,
        'mimeType': 'application/vnd.google-apps.folder',
      }),
    );
    if (created.statusCode != 200) {
      throw _err('create root folder', created);
    }
    return _rootId = (jsonDecode(created.body) as Map)['id'] as String;
  }

  @override
  Future<List<RemoteFile>> listFiles() async {
    final rootId = await ensureRoot();
    final result = <RemoteFile>[];
    String? pageToken;
    do {
      final params = <String, String>{
        'q': "'$rootId' in parents and trashed=false",
        'fields': 'nextPageToken,files(id,name,size,appProperties,modifiedTime)',
        'pageSize': '1000',
        'spaces': 'drive',
      };
      if (pageToken != null) params['pageToken'] = pageToken;
      final uri = Uri.parse('$_base/files').replace(queryParameters: params);
      final res = await http.get(uri, headers: await _authHeader());
      if (res.statusCode != 200) {
        throw _err('list files', res);
      }
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      for (final raw in (json['files'] as List)) {
        final f = raw as Map<String, dynamic>;
        final props = (f['appProperties'] as Map?)?.cast<String, dynamic>();
        final relPath = props?['relPath'] as String? ?? f['name'] as String;
        final id = f['id'] as String;
        _idByRelPath[relPath] = id;
        result.add(RemoteFile(
          id: id,
          relPath: relPath,
          hash: props?['contentHash'] as String?,
          size: int.tryParse('${f['size'] ?? ''}'),
          modifiedMs: DateTime.tryParse('${f['modifiedTime'] ?? ''}')
              ?.millisecondsSinceEpoch,
        ));
      }
      pageToken = json['nextPageToken'] as String?;
    } while (pageToken != null);
    return result;
  }

  @override
  Future<void> download(RemoteFile file, String localPath) async {
    final res = await http.get(
      Uri.parse('$_base/files/${file.id}?alt=media'),
      headers: await _authHeader(),
    );
    if (res.statusCode != 200) {
      throw _err('download', res);
    }
    final out = File(localPath);
    await out.parent.create(recursive: true);
    await out.writeAsBytes(res.bodyBytes);
  }

  @override
  Future<RemoteFile> upload({
    required String localPath,
    required String relPath,
    String? existingId,
  }) async {
    final rootId = await ensureRoot();
    final bytes = await File(localPath).readAsBytes();
    final contentHash = sha256.convert(bytes).toString();
    final id = existingId ?? _idByRelPath[relPath];
    final name = relPath.split('/').last;

    final metadata = <String, dynamic>{
      'name': name,
      'appProperties': {'relPath': relPath, 'contentHash': contentHash},
    };
    if (id == null) metadata['parents'] = [rootId];

    final boundary = 'paperdoc${DateTime.now().microsecondsSinceEpoch}';
    final request = http.Request(
      id == null ? 'POST' : 'PATCH',
      Uri.parse(
          '$_upload/files${id == null ? '' : '/$id'}?uploadType=multipart&fields=id'),
    )
      ..headers['Authorization'] = 'Bearer ${await _auth.token()}'
      ..headers['Content-Type'] = 'multipart/related; boundary=$boundary'
      ..bodyBytes = _multipartRelated(boundary, jsonEncode(metadata), bytes);

    final res = await http.Response.fromStream(await request.send());
    if (res.statusCode != 200) {
      throw _err('upload', res);
    }
    final newId = (jsonDecode(res.body) as Map)['id'] as String;
    _idByRelPath[relPath] = newId;
    return RemoteFile(
        id: newId, relPath: relPath, hash: contentHash, size: bytes.length);
  }

  @override
  Future<void> delete(String id) async {
    final res = await http.delete(
      Uri.parse('$_base/files/$id'),
      headers: await _authHeader(),
    );
    if (res.statusCode != 204 && res.statusCode != 200) {
      throw _err('delete', res);
    }
    _idByRelPath.removeWhere((key, value) => value == id);
  }

  Uint8List _multipartRelated(
      String boundary, String metadataJson, List<int> content) {
    final builder = BytesBuilder();
    builder.add(utf8.encode('--$boundary\r\n'));
    builder
        .add(utf8.encode('Content-Type: application/json; charset=UTF-8\r\n\r\n'));
    builder.add(utf8.encode('$metadataJson\r\n'));
    builder.add(utf8.encode('--$boundary\r\n'));
    builder.add(utf8.encode('Content-Type: application/octet-stream\r\n\r\n'));
    builder.add(content);
    builder.add(utf8.encode('\r\n--$boundary--\r\n'));
    return builder.toBytes();
  }

  Exception _err(String op, http.Response res) =>
      Exception('Drive $op failed (${res.statusCode}): ${res.body}');
}

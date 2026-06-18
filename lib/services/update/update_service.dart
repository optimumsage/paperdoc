import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/file_reveal.dart';
import '../../core/platform_info.dart';

class UpdateInfo {
  const UpdateInfo({
    required this.version,
    required this.releaseUrl,
    this.assetUrl,
    this.assetName,
  });

  final String version; // release tag, e.g. 'v0.2.0'
  final String releaseUrl;
  final String? assetUrl; // download URL for this platform's artifact
  final String? assetName;

  bool get hasAsset => assetUrl != null;
}

/// Checks GitHub Releases for a newer version and installs it from the release
/// artifacts: launches the APK installer on Android; downloads + reveals the
/// archive on desktop for the user to apply.
class UpdateService {
  UpdateService({this.repo = 'optimumsage/paperdoc', http.Client? client})
      : _client = client ?? http.Client();

  final String repo;
  final http.Client _client;

  Future<UpdateInfo?> checkForUpdate() async {
    final res = await _client.get(
      Uri.parse('https://api.github.com/repos/$repo/releases/latest'),
      headers: {'Accept': 'application/vnd.github+json'},
    );
    if (res.statusCode != 200) {
      throw Exception('Could not reach GitHub (${res.statusCode}).');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final tag = json['tag_name'] as String;
    final info = await PackageInfo.fromPlatform();
    if (!isNewerVersion(tag, info.version)) return null;

    final assets =
        (json['assets'] as List? ?? const []).cast<Map<String, dynamic>>();
    final suffix = _assetSuffix();
    Map<String, dynamic>? asset;
    if (suffix != null) {
      for (final a in assets) {
        if ((a['name'] as String).endsWith(suffix)) {
          asset = a;
          break;
        }
      }
    }
    return UpdateInfo(
      version: tag,
      releaseUrl: json['html_url'] as String? ?? '',
      assetUrl: asset?['browser_download_url'] as String?,
      assetName: asset?['name'] as String?,
    );
  }

  Future<void> downloadAndInstall(UpdateInfo info) async {
    final url = info.assetUrl;
    if (url == null) return;
    final res = await _client.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('Download failed (${res.statusCode}).');
    }
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, info.assetName!));
    await file.writeAsBytes(res.bodyBytes);

    if (PlatformInfo.isAndroid) {
      await OpenFilex.open(file.path); // hands off to the package installer
    } else {
      await revealInFileManager(file.path);
    }
  }

  String? _assetSuffix() {
    if (PlatformInfo.isAndroid) return '-android.apk';
    if (Platform.isMacOS) return '-macos.zip';
    if (Platform.isWindows) return '-windows.zip';
    return null;
  }
}

/// True when release [tag] (e.g. 'v0.2.0') is newer than [current] (e.g.
/// '0.1.0'). Tolerant of a leading 'v', build suffixes, and missing parts.
bool isNewerVersion(String tag, String current) {
  final a = _parseVersion(tag);
  final b = _parseVersion(current);
  for (var i = 0; i < 3; i++) {
    if (a[i] != b[i]) return a[i] > b[i];
  }
  return false;
}

List<int> _parseVersion(String v) {
  final cleaned =
      v.replaceAll(RegExp('^[vV]'), '').split('+').first.split('-').first;
  final parts = cleaned.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  while (parts.length < 3) {
    parts.add(0);
  }
  return parts.take(3).toList();
}

import 'dart:convert';

import '../../data/db/app_database.dart';

/// The metadata sidecar that travels with each document's blob in the cloud
/// (`meta/<uid>.json`). Carries the cross-device identity and core fields so a
/// receiving device can recreate the catalog row. Folder/tag organization is
/// not yet synced (documents arrive unfiled) — that's a follow-up.
class DocMeta {
  const DocMeta({
    required this.uid,
    required this.title,
    required this.originalName,
    required this.contentHash,
    required this.docType,
    required this.sizeBytes,
    required this.createdAt,
    required this.importedAt,
    this.ext,
    this.mime,
    this.isEncrypted = false,
    this.encHash,
    this.folderUid,
    this.categoryUid,
    this.tagUids = const [],
    this.labelUids = const [],
  });

  final String uid;
  final String title;
  final String originalName;
  final String contentHash;
  final String docType;
  final int sizeBytes;
  final int createdAt;
  final int importedAt;
  final String? ext;
  final String? mime;
  final String? folderUid;
  final String? categoryUid;
  final List<String> tagUids;
  final List<String> labelUids;

  /// Whether the blob is stored as ciphertext (the cloud only ever sees bytes).
  final bool isEncrypted;

  /// SHA-256 of the ciphertext blob — the hash used for reconciliation when
  /// encrypted (the cloud can't see the plaintext hash).
  final String? encHash;

  factory DocMeta.fromDocument(
    Document d, {
    List<String> tagUids = const [],
    List<String> labelUids = const [],
  }) =>
      DocMeta(
        uid: d.uid,
        title: d.title,
        originalName: d.originalName,
        contentHash: d.contentHash,
        docType: d.docType,
        sizeBytes: d.sizeBytes,
        createdAt: d.createdAt,
        importedAt: d.importedAt,
        ext: d.ext,
        mime: d.mime,
        isEncrypted: d.isEncrypted,
        encHash: d.encHash,
        folderUid: d.folderUid,
        categoryUid: d.categoryUid,
        tagUids: tagUids,
        labelUids: labelUids,
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'title': title,
        'originalName': originalName,
        'contentHash': contentHash,
        'docType': docType,
        'sizeBytes': sizeBytes,
        'createdAt': createdAt,
        'importedAt': importedAt,
        'ext': ext,
        'mime': mime,
        'isEncrypted': isEncrypted,
        'encHash': encHash,
        'folderUid': folderUid,
        'categoryUid': categoryUid,
        'tagUids': tagUids,
        'labelUids': labelUids,
      };

  String toJson() => jsonEncode(toMap());

  factory DocMeta.fromMap(Map<String, dynamic> m) => DocMeta(
        uid: m['uid'] as String,
        title: m['title'] as String,
        originalName: m['originalName'] as String,
        contentHash: m['contentHash'] as String,
        docType: m['docType'] as String? ?? 'other',
        sizeBytes: m['sizeBytes'] as int? ?? 0,
        createdAt: m['createdAt'] as int? ?? 0,
        importedAt: m['importedAt'] as int? ?? 0,
        ext: m['ext'] as String?,
        mime: m['mime'] as String?,
        isEncrypted: m['isEncrypted'] as bool? ?? false,
        encHash: m['encHash'] as String?,
        folderUid: m['folderUid'] as String?,
        categoryUid: m['categoryUid'] as String?,
        tagUids: (m['tagUids'] as List?)?.cast<String>() ?? const [],
        labelUids: (m['labelUids'] as List?)?.cast<String>() ?? const [],
      );

  factory DocMeta.fromJson(String s) =>
      DocMeta.fromMap(jsonDecode(s) as Map<String, dynamic>);
}

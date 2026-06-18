import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../core/clock.dart';
import '../../core/ids.dart';
import '../../data/db/app_database.dart';
import '../library/library_service.dart';
import '../security/library_encryption.dart';
import 'catalog_sync.dart';
import 'cloud_provider.dart';
import 'doc_meta.dart';
import 'reconciler.dart';

class SyncReport {
  int uploaded = 0;
  int downloaded = 0;
  int deletedLocal = 0;
  int deletedRemote = 0;
  int conflicts = 0;

  /// Diagnostics: how many remote catalog snapshots were merged, and how many
  /// folders exist locally after the sync.
  int catalogFiles = 0;
  int folders = 0;

  @override
  String toString() => 'Synced — up:$uploaded down:$downloaded '
      'del:${deletedLocal + deletedRemote} conflicts:$conflicts · '
      'catalogs:$catalogFiles folders:$folders';
}

/// Two-way sync of the document library against a [CloudProvider]. Each document
/// is stored remotely as its blob (`files/<bucket>/<uid>.<ext>`) plus a metadata
/// sidecar (`meta/<uid>.json`). Blob divergence is resolved by the [reconcile]
/// three-way diff; conflicts keep both copies. Document organization
/// (folders/tags) is a later refinement — synced documents arrive unfiled.
class SyncEngine {
  SyncEngine(
    this._db,
    this._library,
    this._provider, {
    Clock clock = const SystemClock(),
    LibraryEncryption? encryption,
  })  : _clock = clock,
        _encryption = encryption;

  final AppDatabase _db;
  final LibraryService _library;
  final CloudProvider _provider;
  final Clock _clock;
  final LibraryEncryption? _encryption;
  late final CatalogSync _catalog = CatalogSync(_db);

  Future<String> _deviceId() async {
    var id = await _db.getSetting('device.id');
    if (id == null) {
      id = newUid();
      await _db.setSetting('device.id', id);
    }
    return id;
  }

  /// Hash of the bytes that actually live on disk / in the cloud — the
  /// ciphertext hash for encrypted documents, the plaintext hash otherwise.
  String _blobHash(Document doc) =>
      doc.isEncrypted ? (doc.encHash ?? doc.contentHash) : doc.contentHash;

  /// Reads the remote encryption manifest, if any (for second-device
  /// onboarding). Returns null when the cloud library isn't encrypted.
  Future<Map<String, dynamic>?> fetchRemoteManifest() async {
    final files = await _provider.listFiles();
    RemoteFile? manifest;
    for (final f in files) {
      if (f.relPath == '.paperdoc/manifest.json') {
        manifest = f;
        break;
      }
    }
    if (manifest == null) return null;
    final dir = await Directory.systemTemp.createTemp('paperdoc_manifest_');
    try {
      final tmp = File(p.join(dir.path, 'manifest.json'));
      await _provider.download(manifest, tmp.path);
      return jsonDecode(await tmp.readAsString()) as Map<String, dynamic>;
    } finally {
      if (dir.existsSync()) await dir.delete(recursive: true);
    }
  }

  Future<SyncReport> sync(int accountId) async {
    final report = SyncReport();
    await _provider.ensureRoot();

    final tmpDir = await Directory.systemTemp.createTemp('paperdoc_sync_');
    try {
      final remoteFiles = await _provider.listFiles();
      final remoteByPath = {for (final f in remoteFiles) f.relPath: f};

      // Merge every device's catalog entities (folders/tags/categories/labels)
      // first, so they exist before documents that reference them are created.
      final catalogSnapshots = <Map<String, dynamic>>[];
      for (final f in remoteFiles) {
        if (f.relPath.startsWith('.paperdoc/catalog/') &&
            f.relPath.endsWith('.json')) {
          final tmp = File(p.join(tmpDir.path,
              'cat_${f.relPath.hashCode.toUnsigned(32)}.json'));
          await _provider.download(f, tmp.path);
          final snapshot =
              jsonDecode(await tmp.readAsString()) as Map<String, dynamic>;
          catalogSnapshots.add(snapshot);
          await _catalog.mergeEntities(snapshot);
          report.catalogFiles++;
        }
      }

      final docs = await (_db.select(_db.documents)
            ..where((t) => t.deleted.equals(false)))
          .get();
      final docByRel = {for (final d in docs) d.relPath: d};
      final local = [for (final d in docs) LocalEntry(d.relPath, _blobHash(d))];

      final remote = [
        for (final f in remoteFiles)
          if (f.relPath.startsWith('files/'))
            RemoteEntry(f.relPath, f.id, f.hash ?? ''),
      ];

      final baseRows = await (_db.select(_db.syncState)
            ..where((t) => t.accountId.equals(accountId)))
          .get();
      final base = [
        for (final b in baseRows)
          if (b.baseHash != null) BaseEntry(b.relPath, b.baseHash!),
      ];

      for (final action in reconcile(local: local, remote: remote, base: base)) {
        switch (action.op) {
          case SyncOp.upload:
            await _upload(accountId, docByRel[action.relPath]!, tmpDir, report);
          case SyncOp.download:
            await _download(accountId, action.relPath, remoteByPath, tmpDir,
                report);
          case SyncOp.deleteLocal:
            await _deleteLocal(accountId, action.relPath, report);
          case SyncOp.deleteRemote:
            await _deleteRemote(accountId, action, remoteByPath, report);
          case SyncOp.conflict:
            await _conflict(
                accountId, action, docByRel, remoteByPath, tmpDir, report);
        }
      }

      // Apply per-document organization (folder/category/tags/title) from every
      // device's snapshot — LWW. This propagates metadata-only changes (moving a
      // document to a folder, renaming) even when the file bytes didn't change.
      for (final snapshot in catalogSnapshots) {
        await _catalog.mergeDocuments(snapshot);
      }

      // Publish this device's catalog snapshot (folders/tags/categories/labels
      // + per-document organization).
      final catalogFile = File(p.join(tmpDir.path, 'catalog.json'));
      await catalogFile.writeAsString(jsonEncode(await _catalog.exportLocal()));
      await _provider.upload(
        localPath: catalogFile.path,
        relPath: '.paperdoc/catalog/${await _deviceId()}.json',
      );

      // Publish the encryption manifest so a second device can onboard.
      if (_encryption != null && await _encryption.isEncrypted()) {
        final manifest = await _encryption.manifestJson();
        if (manifest != null) {
          final f = File(p.join(tmpDir.path, 'manifest.json'));
          await f.writeAsString(manifest);
          await _provider.upload(
              localPath: f.path, relPath: '.paperdoc/manifest.json');
        }
      }

      report.folders = (await (_db.select(_db.folders)
                ..where((t) => t.deleted.equals(false)))
              .get())
          .length;

      await (_db.update(_db.syncAccounts)..where((t) => t.id.equals(accountId)))
          .write(SyncAccountsCompanion(lastSyncAt: Value(_clock.nowMs())));
      return report;
    } finally {
      if (tmpDir.existsSync()) await tmpDir.delete(recursive: true);
    }
  }

  String _metaPath(String uid) => 'meta/$uid.json';

  Future<void> _upload(
    int accountId,
    Document doc,
    Directory tmpDir,
    SyncReport report,
  ) async {
    final state = await _state(accountId, doc.relPath);
    final rf = await _provider.upload(
      localPath: _library.blobFile(doc.relPath).path,
      relPath: doc.relPath,
      existingId: state?.remoteId,
    );

    final tagUids = (await (_db.select(_db.documentTags)
              ..where((t) =>
                  t.documentUid.equals(doc.uid) & t.deleted.equals(false)))
            .get())
        .map((r) => r.tagUid)
        .toList();
    final labelUids = (await (_db.select(_db.documentLabels)
              ..where((t) =>
                  t.documentUid.equals(doc.uid) & t.deleted.equals(false)))
            .get())
        .map((r) => r.labelUid)
        .toList();

    final metaFile = File(p.join(tmpDir.path, '${doc.uid}.json'));
    await metaFile.writeAsString(
        DocMeta.fromDocument(doc, tagUids: tagUids, labelUids: labelUids)
            .toJson());
    await _provider.upload(
      localPath: metaFile.path,
      relPath: _metaPath(doc.uid),
    );

    await _upsertState(
      accountId,
      relPath: doc.relPath,
      hash: _blobHash(doc),
      remoteId: rf.id,
      remoteHash: rf.hash,
    );
    report.uploaded++;
  }

  Future<void> _download(
    int accountId,
    String relPath,
    Map<String, RemoteFile> remoteByPath,
    Directory tmpDir,
    SyncReport report,
  ) async {
    final uid = p.basenameWithoutExtension(relPath);
    final metaRemote = remoteByPath[_metaPath(uid)];
    final blobRemote = remoteByPath[relPath];
    if (metaRemote == null || blobRemote == null) return;

    final metaTmp = File(p.join(tmpDir.path, '$uid.meta.json'));
    await _provider.download(metaRemote, metaTmp.path);
    final meta = DocMeta.fromJson(await metaTmp.readAsString());

    final blob = _library.blobFile(relPath);
    await blob.parent.create(recursive: true);
    await _provider.download(blobRemote, blob.path);

    await _upsertDocument(meta, relPath);
    await _upsertState(
      accountId,
      relPath: relPath,
      // The on-disk hash equals the remote blob hash we just downloaded.
      hash: blobRemote.hash ?? meta.contentHash,
      remoteId: blobRemote.id,
      remoteHash: blobRemote.hash,
    );
    report.downloaded++;
  }

  Future<void> _deleteLocal(
      int accountId, String relPath, SyncReport report) async {
    final doc = await (_db.select(_db.documents)
          ..where((t) => t.relPath.equals(relPath)))
        .getSingleOrNull();
    if (doc != null) {
      await (_db.delete(_db.documentText)
            ..where((t) => t.documentUid.equals(doc.uid)))
          .go();
      await (_db.delete(_db.documents)..where((t) => t.uid.equals(doc.uid)))
          .go();
    }
    await _library.deleteBlob(relPath);
    await _deleteState(accountId, relPath);
    report.deletedLocal++;
  }

  Future<void> _deleteRemote(
    int accountId,
    SyncAction action,
    Map<String, RemoteFile> remoteByPath,
    SyncReport report,
  ) async {
    if (action.remoteId != null) await _provider.delete(action.remoteId!);
    final uid = p.basenameWithoutExtension(action.relPath);
    final metaRemote = remoteByPath[_metaPath(uid)];
    if (metaRemote != null) await _provider.delete(metaRemote.id);
    await _deleteState(accountId, action.relPath);
    report.deletedRemote++;
  }

  /// Keep-both: the remote version is pulled in as a new "(conflict)" document,
  /// while the local version wins the original path (re-uploaded so remote
  /// matches). No bytes are lost.
  Future<void> _conflict(
    int accountId,
    SyncAction action,
    Map<String, Document> docByRel,
    Map<String, RemoteFile> remoteByPath,
    Directory tmpDir,
    SyncReport report,
  ) async {
    final uid = p.basenameWithoutExtension(action.relPath);
    final metaRemote = remoteByPath[_metaPath(uid)];
    final blobRemote = remoteByPath[action.relPath];

    if (metaRemote != null && blobRemote != null) {
      final metaTmp = File(p.join(tmpDir.path, '$uid.conflict.json'));
      await _provider.download(metaRemote, metaTmp.path);
      final meta = DocMeta.fromJson(await metaTmp.readAsString());

      final newId = newUid();
      final ext = meta.ext;
      final newRel =
          'files/${newId.substring(0, 2)}/$newId${ext != null ? '.$ext' : ''}';
      final blob = _library.blobFile(newRel);
      await blob.parent.create(recursive: true);
      await _provider.download(blobRemote, blob.path);

      final now = _clock.nowMs();
      await _db.into(_db.documents).insert(
            DocumentsCompanion.insert(
              uid: newId,
              title: '${meta.title} (conflict)',
              originalName: meta.originalName,
              relPath: newRel,
              contentHash: meta.contentHash,
              createdAt: now,
              updatedAt: now,
              importedAt: now,
              ext: Value(ext),
              mime: Value(meta.mime),
              docType: Value(meta.docType),
              sizeBytes: Value(meta.sizeBytes),
              isEncrypted: Value(meta.isEncrypted),
              encHash: Value(meta.encHash),
            ),
          );
      final conflictDoc = await (_db.select(_db.documents)
            ..where((t) => t.uid.equals(newId)))
          .getSingle();
      await _upload(accountId, conflictDoc, tmpDir, report);
    }

    // Local wins the original path.
    final localDoc = docByRel[action.relPath];
    if (localDoc != null) {
      await _upload(accountId, localDoc, tmpDir, report);
    }
    report.conflicts++;
  }

  Future<void> _upsertDocument(DocMeta meta, String relPath) async {
    final now = _clock.nowMs();
    final existing = await (_db.select(_db.documents)
          ..where((t) => t.uid.equals(meta.uid)))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.documents).insert(
            DocumentsCompanion.insert(
              uid: meta.uid,
              title: meta.title,
              originalName: meta.originalName,
              relPath: relPath,
              contentHash: meta.contentHash,
              createdAt: meta.createdAt == 0 ? now : meta.createdAt,
              updatedAt: now,
              importedAt: meta.importedAt == 0 ? now : meta.importedAt,
              ext: Value(meta.ext),
              mime: Value(meta.mime),
              docType: Value(meta.docType),
              sizeBytes: Value(meta.sizeBytes),
              isEncrypted: Value(meta.isEncrypted),
              encHash: Value(meta.encHash),
              folderUid: Value(meta.folderUid),
              categoryUid: Value(meta.categoryUid),
            ),
          );
    } else {
      await (_db.update(_db.documents)..where((t) => t.uid.equals(meta.uid)))
          .write(DocumentsCompanion(
        title: Value(meta.title),
        contentHash: Value(meta.contentHash),
        relPath: Value(relPath),
        updatedAt: Value(now),
        isEncrypted: Value(meta.isEncrypted),
        encHash: Value(meta.encHash),
        folderUid: Value(meta.folderUid),
        categoryUid: Value(meta.categoryUid),
      ));
    }

    // Re-apply tag/label assignments (entities already merged via catalog sync).
    for (final tagUid in meta.tagUids) {
      await _db.into(_db.documentTags).insertOnConflictUpdate(
            DocumentTagsCompanion.insert(
              documentUid: meta.uid,
              tagUid: tagUid,
              createdAt: now,
              updatedAt: now,
              deleted: const Value(false),
            ),
          );
    }
    for (final labelUid in meta.labelUids) {
      await _db.into(_db.documentLabels).insertOnConflictUpdate(
            DocumentLabelsCompanion.insert(
              documentUid: meta.uid,
              labelUid: labelUid,
              createdAt: now,
              updatedAt: now,
              deleted: const Value(false),
            ),
          );
    }
  }

  Future<SyncStateData?> _state(int accountId, String relPath) =>
      (_db.select(_db.syncState)
            ..where((t) =>
                t.accountId.equals(accountId) & t.relPath.equals(relPath)))
          .getSingleOrNull();

  Future<void> _upsertState(
    int accountId, {
    required String relPath,
    required String hash,
    required String remoteId,
    required String? remoteHash,
  }) async {
    final now = _clock.nowMs();
    final existing = await _state(accountId, relPath);
    if (existing == null) {
      await _db.into(_db.syncState).insert(
            SyncStateCompanion.insert(
              accountId: accountId,
              relPath: relPath,
              localHash: Value(hash),
              remoteId: Value(remoteId),
              remoteHash: Value(remoteHash),
              baseHash: Value(hash),
              state: const Value('synced'),
              lastSyncedAt: Value(now),
            ),
          );
    } else {
      await (_db.update(_db.syncState)
            ..where((t) => t.id.equals(existing.id)))
          .write(SyncStateCompanion(
        localHash: Value(hash),
        remoteId: Value(remoteId),
        remoteHash: Value(remoteHash),
        baseHash: Value(hash),
        state: const Value('synced'),
        lastSyncedAt: Value(now),
      ));
    }
  }

  Future<void> _deleteState(int accountId, String relPath) =>
      (_db.delete(_db.syncState)
            ..where((t) =>
                t.accountId.equals(accountId) & t.relPath.equals(relPath)))
          .go();
}

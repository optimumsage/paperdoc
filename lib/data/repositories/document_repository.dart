import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../core/clock.dart';
import '../../core/doc_type.dart';
import '../../core/hashing.dart';
import '../../core/ids.dart';
import '../../services/library/library_service.dart';
import '../../services/ocr/ocr_service.dart';
import '../../services/search/search_indexer.dart';
import '../../services/search/text_extractor.dart';
import '../../services/security/library_encryption.dart';
import '../db/app_database.dart';

/// Ordering options for the document list.
enum DocumentSort { recent, nameAsc, modified, sizeDesc, typeAsc }

/// Groups documents that share the same content hash (exact duplicates),
/// returning only the groups with more than one member.
List<List<Document>> groupDuplicates(List<Document> docs) {
  final byHash = <String, List<Document>>{};
  for (final d in docs) {
    byHash.putIfAbsent(d.contentHash, () => []).add(d);
  }
  return byHash.values.where((group) => group.length > 1).toList();
}

/// All reads and writes for documents. Coordinates catalog rows (the database)
/// with content blobs on disk (via [LibraryService]). Every mutation bumps
/// `updatedAt` and `revision` so M5 sync can detect local changes.
class DocumentRepository {
  DocumentRepository(
    this._db,
    this._library, {
    Clock clock = const SystemClock(),
    SearchIndexer? indexer,
    TextExtractor extractor = const TextExtractor(),
    LibraryEncryption? encryption,
  })  : _clock = clock,
        _extractor = extractor,
        _encryption = encryption {
    _indexer = indexer ?? SearchIndexer(_db);
  }

  final AppDatabase _db;
  final LibraryService _library;
  final Clock _clock;
  final TextExtractor _extractor;
  final LibraryEncryption? _encryption;
  late final SearchIndexer _indexer;

  // ---- Reads ----

  Stream<List<Document>> watchInFolder(
    String? folderUid, {
    DocumentSort sort = DocumentSort.recent,
  }) {
    return (_db.select(_db.documents)
          ..where((t) =>
              t.deleted.equals(false) &
              (folderUid == null
                  ? t.folderUid.isNull()
                  : t.folderUid.equals(folderUid)))
          ..orderBy(_orderBy(sort)))
        .watch();
  }

  Stream<List<Document>> watchAll({DocumentSort sort = DocumentSort.recent}) {
    return (_db.select(_db.documents)
          ..where((t) => t.deleted.equals(false))
          ..orderBy(_orderBy(sort)))
        .watch();
  }

  List<OrderingTerm Function($DocumentsTable)> _orderBy(DocumentSort sort) {
    switch (sort) {
      case DocumentSort.recent:
        return [
          (t) => OrderingTerm(expression: t.importedAt, mode: OrderingMode.desc),
        ];
      case DocumentSort.nameAsc:
        return [
          (t) => OrderingTerm(expression: t.title.collate(Collate.noCase)),
        ];
      case DocumentSort.modified:
        return [
          (t) => OrderingTerm(expression: t.fileMtime, mode: OrderingMode.desc),
          (t) => OrderingTerm(expression: t.importedAt, mode: OrderingMode.desc),
        ];
      case DocumentSort.sizeDesc:
        return [
          (t) => OrderingTerm(expression: t.sizeBytes, mode: OrderingMode.desc),
        ];
      case DocumentSort.typeAsc:
        return [
          (t) => OrderingTerm(expression: t.docType),
          (t) => OrderingTerm(expression: t.title.collate(Collate.noCase)),
        ];
    }
  }

  Stream<List<Document>> watchTrash() {
    return (_db.select(_db.documents)
          ..where((t) => t.deleted.equals(true))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.deletedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<Document?> findByUid(String uid) =>
      (_db.select(_db.documents)..where((t) => t.uid.equals(uid)))
          .getSingleOrNull();

  /// Live groups of exact-duplicate documents (same content hash).
  Stream<List<List<Document>>> watchDuplicates() =>
      watchAll().map(groupDuplicates);

  Future<List<List<Document>>> duplicateGroups() async =>
      groupDuplicates(await watchAll().first);

  /// Live view of a single document, so a detail panel updates as the document
  /// is edited (star, category, rename).
  Stream<Document?> watchByUid(String uid) =>
      (_db.select(_db.documents)..where((t) => t.uid.equals(uid)))
          .watchSingleOrNull();

  /// Extracts text for any extractable document that doesn't have it yet (e.g.
  /// PDFs/Office files imported before content extraction existed). Idempotent;
  /// safe to run on every library open. Returns the number newly indexed.
  Future<int> reextractMissing() async {
    final docs = await (_db.select(_db.documents)
          ..where((t) =>
              t.deleted.equals(false) &
              t.isEncrypted.equals(false) &
              // Cloud-only placeholders have no blob on disk to extract from.
              t.downloadState.equals('local') &
              t.docType.isIn([DocType.pdf, DocType.office, DocType.text])))
        .get();
    var indexed = 0;
    for (final doc in docs) {
      final hasText = await (_db.select(_db.documentText)
            ..where((t) => t.documentUid.equals(doc.uid)))
          .getSingleOrNull();
      if (hasText != null) continue;

      final extracted = await _extractor.extract(
        file: _library.blobFile(doc.relPath),
        docType: doc.docType,
        ext: doc.ext,
      );
      if (extracted == null) continue;
      await _db.into(_db.documentText).insertOnConflictUpdate(
            DocumentTextCompanion.insert(
              documentUid: doc.uid,
              source: extracted.source,
              extractedAt: _clock.nowMs(),
              content: Value(extracted.content),
              charCount: Value(extracted.content.length),
              engine: const Value('builtin'),
            ),
          );
      await _indexer.index(
          uid: doc.uid, title: doc.title, body: extracted.content);
      indexed++;
    }
    return indexed;
  }

  // ---- Import ----

  /// Imports a file from [sourcePath] into the library: hashes it, places the
  /// blob, and creates the catalog row. With [move] true the original is
  /// removed after placement.
  Future<Document> importFile(
    String sourcePath, {
    String? folderUid,
    String? categoryUid,
    bool move = false,
  }) async {
    final src = File(sourcePath);
    final stat = await src.stat();
    final originalName = p.basename(sourcePath);
    final rawExt = p.extension(sourcePath).replaceFirst('.', '').toLowerCase();
    final ext = rawExt.isEmpty ? null : rawExt;
    final docType = DocType.fromExtension(ext);

    final hash = await sha256OfFile(src);
    final uid = newUid();
    final relPath = _library.relPathFor(uid, ext);
    final now = _clock.nowMs();

    // Extract searchable text from the plaintext source before any encryption.
    final extracted =
        await _extractor.extract(file: src, docType: docType, ext: ext);

    // Place the blob — encrypting it for an unlocked encrypted library.
    final encrypting = await _encryption?.shouldEncrypt() ?? false;
    String? encHash;
    if (encrypting) {
      final cipher = await _encryption!.encrypt(await src.readAsBytes());
      final dest = _library.blobFile(relPath);
      await dest.parent.create(recursive: true);
      await dest.writeAsBytes(cipher);
      if (move) await src.delete();
      encHash = sha256.convert(cipher).toString();
    } else {
      await _library.placeBlob(
          sourcePath: sourcePath, relPath: relPath, move: move);
    }

    final id = await _db.into(_db.documents).insert(
          DocumentsCompanion.insert(
            uid: uid,
            title: p.basenameWithoutExtension(originalName),
            originalName: originalName,
            relPath: relPath,
            contentHash: hash,
            createdAt: now,
            updatedAt: now,
            importedAt: now,
            ext: Value(ext),
            docType: Value(docType),
            // Images and scanned PDFs (no extractable text) queue for OCR —
            // including encrypted ones, which are decrypted at OCR time.
            ocrStatus: Value(
              docType == DocType.image ||
                      (docType == DocType.pdf && extracted == null)
                  ? OcrStatus.pending
                  : OcrStatus.none,
            ),
            sizeBytes: Value(stat.size),
            fileMtime: Value(stat.modified.millisecondsSinceEpoch),
            folderUid: Value(folderUid),
            categoryUid: Value(categoryUid),
            isEncrypted: Value(encrypting),
            encHash: Value(encHash),
          ),
        );
    final doc = await (_db.select(_db.documents)..where((t) => t.id.equals(id)))
        .getSingle();

    String? body;
    if (extracted != null) {
      await _db.into(_db.documentText).insertOnConflictUpdate(
            DocumentTextCompanion.insert(
              documentUid: doc.uid,
              source: extracted.source,
              extractedAt: now,
              content: Value(extracted.content),
              charCount: Value(extracted.content.length),
              engine: const Value('builtin'),
            ),
          );
      body = extracted.content;
    }
    await _indexer.index(uid: doc.uid, title: doc.title, body: body);
    return doc;
  }

  // ---- Mutations ----

  Future<void> rename(String uid, String newTitle) async {
    await _update(
      uid,
      (cur) => DocumentsCompanion(
        title: Value(newTitle),
        updatedAt: Value(_clock.nowMs()),
        revision: Value(cur.revision + 1),
      ),
    );
    await _indexer.reindexDocument(uid);
  }

  Future<void> moveToFolder(String uid, String? folderUid) => _update(
        uid,
        (cur) => DocumentsCompanion(
          folderUid: Value(folderUid),
          updatedAt: Value(_clock.nowMs()),
          revision: Value(cur.revision + 1),
        ),
      );

  Future<void> setCategory(String uid, String? categoryUid) => _update(
        uid,
        (cur) => DocumentsCompanion(
          categoryUid: Value(categoryUid),
          updatedAt: Value(_clock.nowMs()),
          revision: Value(cur.revision + 1),
        ),
      );

  Future<void> setStarred(String uid, bool starred) => _update(
        uid,
        (cur) => DocumentsCompanion(
          starred: Value(starred),
          updatedAt: Value(_clock.nowMs()),
          revision: Value(cur.revision + 1),
        ),
      );

  /// Sets a document's on-demand availability. This is a per-device field and
  /// deliberately does NOT bump `updatedAt`/`revision` — it must never trigger
  /// a sync upload.
  Future<void> setDownloadState(String uid, String state) =>
      (_db.update(_db.documents)..where((t) => t.uid.equals(uid)))
          .write(DocumentsCompanion(downloadState: Value(state)));

  /// Reverts a locally-cached document to a cloud-only placeholder, deleting
  /// its on-disk blob to free space. Returns false (and does nothing) unless the
  /// document is backed by a remote copy — we never delete the only copy.
  Future<bool> freeUpSpace(String uid) async {
    final doc = await findByUid(uid);
    if (doc == null || doc.downloadState != 'local') return false;
    final backed = await (_db.select(_db.syncState)
          ..where((t) =>
              t.relPath.equals(doc.relPath) & t.remoteId.isNotNull()))
        .getSingleOrNull();
    if (backed == null) return false;
    await _library.deleteBlob(doc.relPath);
    await setDownloadState(uid, 'cloud');
    return true;
  }

  /// Duplicates a document: copies the blob to a fresh uid and inserts a new
  /// catalog row in the same folder.
  Future<Document> copyDocument(String uid) async {
    final srcDoc = await findByUid(uid);
    if (srcDoc == null) {
      throw StateError('Document $uid not found');
    }
    final newUidVal = newUid();
    final newRel = _library.relPathFor(newUidVal, srcDoc.ext);
    await _library.copyBlob(fromRelPath: srcDoc.relPath, toRelPath: newRel);

    final now = _clock.nowMs();
    final id = await _db.into(_db.documents).insert(
          DocumentsCompanion.insert(
            uid: newUidVal,
            title: '${srcDoc.title} copy',
            originalName: srcDoc.originalName,
            relPath: newRel,
            contentHash: srcDoc.contentHash,
            createdAt: now,
            updatedAt: now,
            importedAt: now,
            ext: Value(srcDoc.ext),
            mime: Value(srcDoc.mime),
            docType: Value(srcDoc.docType),
            sizeBytes: Value(srcDoc.sizeBytes),
            folderUid: Value(srcDoc.folderUid),
            categoryUid: Value(srcDoc.categoryUid),
            isEncrypted: Value(srcDoc.isEncrypted),
            encHash: Value(srcDoc.encHash),
          ),
        );
    final copy = await (_db.select(_db.documents)..where((t) => t.id.equals(id)))
        .getSingle();

    // Carry over extracted text + index entry so the copy is searchable too.
    final srcText = await (_db.select(_db.documentText)
          ..where((t) => t.documentUid.equals(srcDoc.uid)))
        .getSingleOrNull();
    if (srcText != null) {
      await _db.into(_db.documentText).insertOnConflictUpdate(
            DocumentTextCompanion.insert(
              documentUid: copy.uid,
              source: srcText.source,
              extractedAt: _clock.nowMs(),
              content: Value(srcText.content),
              charCount: Value(srcText.charCount),
              lang: Value(srcText.lang),
              engine: Value(srcText.engine),
            ),
          );
    }
    await _indexer.index(
        uid: copy.uid, title: copy.title, body: srcText?.content);
    return copy;
  }

  /// Soft delete → moves the document to Trash. The blob stays on disk (and in
  /// the cloud) so it can be restored.
  Future<void> softDelete(String uid) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    final now = _clock.nowMs();
    await _db.transaction(() async {
      await (_db.update(_db.documents)..where((t) => t.uid.equals(uid))).write(
        DocumentsCompanion(
          deleted: const Value(true),
          deletedAt: Value(now),
          updatedAt: Value(now),
          revision: Value(cur.revision + 1),
        ),
      );
      await _db.into(_db.trashMeta).insertOnConflictUpdate(
            TrashMetaCompanion.insert(
              documentUid: uid,
              trashedAt: now,
              originFolderUid: Value(cur.folderUid),
            ),
          );
    });
  }

  /// Restores a trashed document to its original folder.
  Future<void> restore(String uid) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    final now = _clock.nowMs();
    await _db.transaction(() async {
      await (_db.update(_db.documents)..where((t) => t.uid.equals(uid))).write(
        DocumentsCompanion(
          deleted: const Value(false),
          deletedAt: const Value(null),
          updatedAt: Value(now),
          revision: Value(cur.revision + 1),
        ),
      );
      await (_db.delete(_db.trashMeta)..where((t) => t.documentUid.equals(uid)))
          .go();
    });
  }

  /// Permanently removes a document: deletes the blob, its tag/label links,
  /// trash metadata, and the catalog row.
  Future<void> permanentDelete(String uid) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    await _library.deleteBlob(cur.relPath);
    await _db.transaction(() async {
      await (_db.delete(_db.documentTags)
            ..where((t) => t.documentUid.equals(uid)))
          .go();
      await (_db.delete(_db.documentLabels)
            ..where((t) => t.documentUid.equals(uid)))
          .go();
      await (_db.delete(_db.documentText)
            ..where((t) => t.documentUid.equals(uid)))
          .go();
      await (_db.delete(_db.trashMeta)..where((t) => t.documentUid.equals(uid)))
          .go();
      await (_db.delete(_db.documents)..where((t) => t.uid.equals(uid))).go();
    });
    await _indexer.remove(uid);
  }

  // ---- Bulk operations (multi-select) ----

  Future<void> bulkMoveToFolder(Iterable<String> uids, String? folderUid) async {
    for (final uid in uids) {
      await moveToFolder(uid, folderUid);
    }
  }

  Future<void> bulkSetStarred(Iterable<String> uids, bool starred) async {
    for (final uid in uids) {
      await setStarred(uid, starred);
    }
  }

  Future<void> bulkSoftDelete(Iterable<String> uids) async {
    for (final uid in uids) {
      await softDelete(uid);
    }
  }

  Future<void> bulkRestore(Iterable<String> uids) async {
    for (final uid in uids) {
      await restore(uid);
    }
  }

  /// Permanently deletes everything currently in the Trash.
  Future<void> emptyTrash() async {
    final trashed =
        await (_db.select(_db.documents)..where((t) => t.deleted.equals(true)))
            .get();
    for (final d in trashed) {
      await permanentDelete(d.uid);
    }
  }

  Future<void> _update(
    String uid,
    DocumentsCompanion Function(Document current) build,
  ) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    await (_db.update(_db.documents)..where((t) => t.uid.equals(uid)))
        .write(build(cur));
  }
}

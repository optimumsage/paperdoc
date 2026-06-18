import '../../data/db/app_database.dart';

/// Maintains the `documents_fts` FTS5 table. The index holds one row per
/// document: its title and extracted body text. Trashed documents are left in
/// the index (search filters them out via `documents.deleted`), and removed
/// only on permanent delete.
class SearchIndexer {
  SearchIndexer(this._db);

  final AppDatabase _db;

  Future<void> index({
    required String uid,
    required String title,
    String? body,
  }) async {
    await _db.transaction(() async {
      await _db
          .customStatement('DELETE FROM documents_fts WHERE uid = ?', [uid]);
      await _db.customStatement(
        'INSERT INTO documents_fts(uid, title, body) VALUES (?, ?, ?)',
        [uid, title, body ?? ''],
      );
    });
  }

  Future<void> remove(String uid) =>
      _db.customStatement('DELETE FROM documents_fts WHERE uid = ?', [uid]);

  /// Rebuilds a document's index row from its current title and stored text.
  Future<void> reindexDocument(String uid) async {
    final doc = await (_db.select(_db.documents)
          ..where((t) => t.uid.equals(uid)))
        .getSingleOrNull();
    if (doc == null) return;
    final textRow = await (_db.select(_db.documentText)
          ..where((t) => t.documentUid.equals(uid)))
        .getSingleOrNull();
    await index(uid: uid, title: doc.title, body: textRow?.content);
  }
}

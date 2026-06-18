import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'document_repository.dart';

/// Reads and resolves watch suggestions. Accepting imports the file into the
/// library; dismissing hides it so it won't be suggested again.
class WatchSuggestionRepository {
  WatchSuggestionRepository(this._db, this._documents);

  final AppDatabase _db;
  final DocumentRepository _documents;

  Stream<List<WatchSuggestion>> watchPending() =>
      (_db.select(_db.watchSuggestions)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.detectedAt, mode: OrderingMode.desc),
            ]))
          .watch();

  Future<void> accept(WatchSuggestion suggestion) async {
    await _documents.importFile(
      suggestion.srcPath,
      folderUid: suggestion.suggestedFolderUid,
    );
    await _setStatus(suggestion.id, 'accepted');
  }

  Future<void> dismiss(int id) => _setStatus(id, 'dismissed');

  Future<void> _setStatus(int id, String status) =>
      (_db.update(_db.watchSuggestions)..where((t) => t.id.equals(id)))
          .write(WatchSuggestionsCompanion(status: Value(status)));
}

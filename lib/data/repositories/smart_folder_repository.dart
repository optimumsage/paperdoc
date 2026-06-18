import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/ids.dart';
import '../db/app_database.dart';
import '../models/search_query.dart';

/// CRUD for smart folders — named, saved [SearchQuery]s. The query is stored as
/// JSON in `smart_folders.queryJson`.
class SmartFolderRepository {
  SmartFolderRepository(this._db, {Clock clock = const SystemClock()})
      : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  Stream<List<SmartFolder>> watchAll() {
    return (_db.select(_db.smartFolders)
          ..where((t) => t.deleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .watch();
  }

  Future<SmartFolder> create({
    required String name,
    required SearchQuery query,
    String? icon,
  }) async {
    final uid = newUid();
    final now = _clock.nowMs();
    final id = await _db.into(_db.smartFolders).insert(
          SmartFoldersCompanion.insert(
            uid: uid,
            name: name,
            queryJson: query.toJson(),
            createdAt: now,
            updatedAt: now,
            icon: Value(icon),
          ),
        );
    return (_db.select(_db.smartFolders)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Future<void> rename(String uid, String newName) async {
    final cur = await (_db.select(_db.smartFolders)
          ..where((t) => t.uid.equals(uid)))
        .getSingleOrNull();
    if (cur == null) return;
    await (_db.update(_db.smartFolders)..where((t) => t.uid.equals(uid))).write(
      SmartFoldersCompanion(
        name: Value(newName),
        updatedAt: Value(_clock.nowMs()),
        revision: Value(cur.revision + 1),
      ),
    );
  }

  Future<void> delete(String uid) async {
    await (_db.update(_db.smartFolders)..where((t) => t.uid.equals(uid))).write(
      SmartFoldersCompanion(
        deleted: const Value(true),
        updatedAt: Value(_clock.nowMs()),
      ),
    );
  }

  SearchQuery queryOf(SmartFolder folder) =>
      SearchQuery.fromJson(folder.queryJson);
}

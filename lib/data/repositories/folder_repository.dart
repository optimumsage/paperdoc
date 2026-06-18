import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/ids.dart';
import '../db/app_database.dart';

/// CRUD for the folder tree. Folders are a hierarchy via [Folder.parentUid]
/// (null = top level). Deleting a folder promotes its direct children (sub
/// folders and documents) up to the deleted folder's parent so nothing is
/// silently lost.
class FolderRepository {
  FolderRepository(this._db, {Clock clock = const SystemClock()})
      : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  Stream<List<Folder>> watchAll() {
    return (_db.select(_db.folders)
          ..where((t) => t.deleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .watch();
  }

  Stream<List<Folder>> watchChildren(String? parentUid) {
    return (_db.select(_db.folders)
          ..where((t) =>
              t.deleted.equals(false) &
              (parentUid == null
                  ? t.parentUid.isNull()
                  : t.parentUid.equals(parentUid)))
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .watch();
  }

  Future<Folder?> findByUid(String uid) =>
      (_db.select(_db.folders)..where((t) => t.uid.equals(uid)))
          .getSingleOrNull();

  Future<Folder> create({
    required String name,
    String? parentUid,
    String? color,
  }) async {
    final uid = newUid();
    final now = _clock.nowMs();
    final id = await _db.into(_db.folders).insert(
          FoldersCompanion.insert(
            uid: uid,
            name: name,
            createdAt: now,
            updatedAt: now,
            parentUid: Value(parentUid),
            color: Value(color),
          ),
        );
    return (_db.select(_db.folders)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> rename(String uid, String newName) => _update(
        uid,
        (cur) => FoldersCompanion(
          name: Value(newName),
          updatedAt: Value(_clock.nowMs()),
          revision: Value(cur.revision + 1),
        ),
      );

  Future<void> move(String uid, String? newParentUid) => _update(
        uid,
        (cur) => FoldersCompanion(
          parentUid: Value(newParentUid),
          updatedAt: Value(_clock.nowMs()),
          revision: Value(cur.revision + 1),
        ),
      );

  Future<void> setColor(String uid, String? color) => _update(
        uid,
        (cur) => FoldersCompanion(
          color: Value(color),
          updatedAt: Value(_clock.nowMs()),
          revision: Value(cur.revision + 1),
        ),
      );

  /// Soft-deletes a folder, promoting its direct sub-folders and documents to
  /// the deleted folder's parent.
  Future<void> softDelete(String uid) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    final now = _clock.nowMs();
    await _db.transaction(() async {
      await (_db.update(_db.folders)..where((t) => t.parentUid.equals(uid)))
          .write(FoldersCompanion(
        parentUid: Value(cur.parentUid),
        updatedAt: Value(now),
      ));
      await (_db.update(_db.documents)..where((t) => t.folderUid.equals(uid)))
          .write(DocumentsCompanion(
        folderUid: Value(cur.parentUid),
        updatedAt: Value(now),
      ));
      await (_db.update(_db.folders)..where((t) => t.uid.equals(uid)))
          .write(FoldersCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
        revision: Value(cur.revision + 1),
      ));
    });
  }

  Future<void> _update(
    String uid,
    FoldersCompanion Function(Folder current) build,
  ) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    await (_db.update(_db.folders)..where((t) => t.uid.equals(uid)))
        .write(build(cur));
  }
}

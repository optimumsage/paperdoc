import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/ids.dart';
import '../db/app_database.dart';

/// CRUD for categories. Unlike tags, a document belongs to at most one
/// category (stored on `documents.categoryUid`), so assignment lives in
/// [DocumentRepository.setCategory]; this repo manages the category set itself.
class CategoryRepository {
  CategoryRepository(this._db, {Clock clock = const SystemClock()})
      : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  Stream<List<Category>> watchAll() {
    return (_db.select(_db.categories)
          ..where((t) => t.deleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }

  Future<Category?> findByUid(String uid) =>
      (_db.select(_db.categories)..where((t) => t.uid.equals(uid)))
          .getSingleOrNull();

  Future<Category> create({
    required String name,
    String? icon,
    String? color,
  }) async {
    final uid = newUid();
    final now = _clock.nowMs();
    final id = await _db.into(_db.categories).insert(
          CategoriesCompanion.insert(
            uid: uid,
            name: name,
            createdAt: now,
            updatedAt: now,
            icon: Value(icon),
            color: Value(color),
          ),
        );
    return (_db.select(_db.categories)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Future<void> rename(String uid, String newName) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    await (_db.update(_db.categories)..where((t) => t.uid.equals(uid))).write(
      CategoriesCompanion(
        name: Value(newName),
        updatedAt: Value(_clock.nowMs()),
        revision: Value(cur.revision + 1),
      ),
    );
  }

  Future<void> softDelete(String uid) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    final now = _clock.nowMs();
    await _db.transaction(() async {
      await (_db.update(_db.categories)..where((t) => t.uid.equals(uid))).write(
        CategoriesCompanion(
          deleted: const Value(true),
          updatedAt: Value(now),
          revision: Value(cur.revision + 1),
        ),
      );
      // Detach documents from the removed category.
      await (_db.update(_db.documents)
            ..where((t) => t.categoryUid.equals(uid)))
          .write(DocumentsCompanion(
        categoryUid: const Value(null),
        updatedAt: Value(now),
      ));
    });
  }
}

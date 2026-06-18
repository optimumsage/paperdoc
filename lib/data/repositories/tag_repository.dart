import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/ids.dart';
import '../db/app_database.dart';

/// CRUD for free-form tags plus the M:N document↔tag assignment. Assignments
/// are tombstoned (soft-deleted) rather than hard-deleted so that removals
/// propagate cleanly via sync in M5 (remove-wins policy).
class TagRepository {
  TagRepository(this._db, {Clock clock = const SystemClock()})
      : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  Stream<List<Tag>> watchAll() {
    return (_db.select(_db.tags)
          ..where((t) => t.deleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }

  Future<Tag?> findByUid(String uid) =>
      (_db.select(_db.tags)..where((t) => t.uid.equals(uid)))
          .getSingleOrNull();

  Future<Tag> create({required String name, String? color}) async {
    final uid = newUid();
    final now = _clock.nowMs();
    final id = await _db.into(_db.tags).insert(
          TagsCompanion.insert(
            uid: uid,
            name: name,
            createdAt: now,
            updatedAt: now,
            color: Value(color),
          ),
        );
    return (_db.select(_db.tags)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> rename(String uid, String newName) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    await (_db.update(_db.tags)..where((t) => t.uid.equals(uid))).write(
      TagsCompanion(
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
      await (_db.update(_db.tags)..where((t) => t.uid.equals(uid))).write(
        TagsCompanion(
          deleted: const Value(true),
          updatedAt: Value(now),
          revision: Value(cur.revision + 1),
        ),
      );
      // Tombstone every assignment of this tag.
      await (_db.update(_db.documentTags)..where((t) => t.tagUid.equals(uid)))
          .write(DocumentTagsCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
      ));
    });
  }

  Future<void> assign(String documentUid, String tagUid) async {
    final now = _clock.nowMs();
    await _db.into(_db.documentTags).insertOnConflictUpdate(
          DocumentTagsCompanion.insert(
            documentUid: documentUid,
            tagUid: tagUid,
            createdAt: now,
            updatedAt: now,
            deleted: const Value(false),
          ),
        );
  }

  Future<void> unassign(String documentUid, String tagUid) async {
    await (_db.update(_db.documentTags)
          ..where((t) =>
              t.documentUid.equals(documentUid) & t.tagUid.equals(tagUid)))
        .write(DocumentTagsCompanion(
      deleted: const Value(true),
      updatedAt: Value(_clock.nowMs()),
    ));
  }

  /// The (non-removed) tags currently applied to a document.
  Stream<List<Tag>> watchTagsForDocument(String documentUid) {
    final query = _db.select(_db.tags).join([
      innerJoin(
        _db.documentTags,
        _db.documentTags.tagUid.equalsExp(_db.tags.uid) &
            _db.documentTags.documentUid.equals(documentUid) &
            _db.documentTags.deleted.equals(false),
      ),
    ])
      ..where(_db.tags.deleted.equals(false))
      ..orderBy([OrderingTerm(expression: _db.tags.name)]);
    return query
        .watch()
        .map((rows) => rows.map((r) => r.readTable(_db.tags)).toList());
  }
}

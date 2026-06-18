import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/ids.dart';
import '../db/app_database.dart';

/// CRUD for labels plus the M:N document↔label assignment. Labels are like
/// tags but carry a [Label.kind] (e.g. 'status', 'priority') so the UI can
/// render constrained sets distinctly. Assignments are tombstoned like tags.
class LabelRepository {
  LabelRepository(this._db, {Clock clock = const SystemClock()})
      : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  Stream<List<Label>> watchAll() {
    return (_db.select(_db.labels)
          ..where((t) => t.deleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }

  Future<Label?> findByUid(String uid) =>
      (_db.select(_db.labels)..where((t) => t.uid.equals(uid)))
          .getSingleOrNull();

  Future<Label> create({
    required String name,
    String? color,
    String? kind,
  }) async {
    final uid = newUid();
    final now = _clock.nowMs();
    final id = await _db.into(_db.labels).insert(
          LabelsCompanion.insert(
            uid: uid,
            name: name,
            createdAt: now,
            updatedAt: now,
            color: Value(color),
            kind: Value(kind),
          ),
        );
    return (_db.select(_db.labels)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> rename(String uid, String newName) async {
    final cur = await findByUid(uid);
    if (cur == null) return;
    await (_db.update(_db.labels)..where((t) => t.uid.equals(uid))).write(
      LabelsCompanion(
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
      await (_db.update(_db.labels)..where((t) => t.uid.equals(uid))).write(
        LabelsCompanion(
          deleted: const Value(true),
          updatedAt: Value(now),
          revision: Value(cur.revision + 1),
        ),
      );
      await (_db.update(_db.documentLabels)
            ..where((t) => t.labelUid.equals(uid)))
          .write(DocumentLabelsCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
      ));
    });
  }

  Future<void> assign(String documentUid, String labelUid) async {
    final now = _clock.nowMs();
    await _db.into(_db.documentLabels).insertOnConflictUpdate(
          DocumentLabelsCompanion.insert(
            documentUid: documentUid,
            labelUid: labelUid,
            createdAt: now,
            updatedAt: now,
            deleted: const Value(false),
          ),
        );
  }

  Future<void> unassign(String documentUid, String labelUid) async {
    await (_db.update(_db.documentLabels)
          ..where((t) =>
              t.documentUid.equals(documentUid) & t.labelUid.equals(labelUid)))
        .write(DocumentLabelsCompanion(
      deleted: const Value(true),
      updatedAt: Value(_clock.nowMs()),
    ));
  }

  Stream<List<Label>> watchLabelsForDocument(String documentUid) {
    final query = _db.select(_db.labels).join([
      innerJoin(
        _db.documentLabels,
        _db.documentLabels.labelUid.equalsExp(_db.labels.uid) &
            _db.documentLabels.documentUid.equals(documentUid) &
            _db.documentLabels.deleted.equals(false),
      ),
    ])
      ..where(_db.labels.deleted.equals(false))
      ..orderBy([OrderingTerm(expression: _db.labels.name)]);
    return query
        .watch()
        .map((rows) => rows.map((r) => r.readTable(_db.labels)).toList());
  }
}

import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../db/app_database.dart';

/// CRUD for watched directories (e.g. Downloads). New files appearing in these
/// directories are surfaced as suggestions to add to the library.
class WatchDirRepository {
  WatchDirRepository(this._db, {Clock clock = const SystemClock()})
      : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  Stream<List<WatchDir>> watchAll() =>
      (_db.select(_db.watchDirs)..orderBy([(t) => OrderingTerm(expression: t.path)]))
          .watch();

  Future<List<WatchDir>> enabledDirs() =>
      (_db.select(_db.watchDirs)..where((t) => t.enabled.equals(true))).get();

  Future<WatchDir> add({
    required String path,
    bool recursive = false,
    String? globInclude,
    String? defaultFolderUid,
  }) async {
    final id = await _db.into(_db.watchDirs).insertOnConflictUpdate(
          WatchDirsCompanion.insert(
            path: path,
            createdAt: _clock.nowMs(),
            recursive: Value(recursive),
            globInclude: Value(globInclude),
            defaultFolderUid: Value(defaultFolderUid),
          ),
        );
    return (_db.select(_db.watchDirs)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Future<void> setEnabled(int id, bool enabled) =>
      (_db.update(_db.watchDirs)..where((t) => t.id.equals(id)))
          .write(WatchDirsCompanion(enabled: Value(enabled)));

  Future<void> remove(int id) =>
      (_db.delete(_db.watchDirs)..where((t) => t.id.equals(id))).go();
}

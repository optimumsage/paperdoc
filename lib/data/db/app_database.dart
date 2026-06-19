import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Simple key/value store for app-level configuration that isn't tied to a
/// specific library (e.g. last-opened library path, theme mode).
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    AppSettings,
    Folders,
    Categories,
    Tags,
    Labels,
    Documents,
    DocumentTags,
    DocumentLabels,
    TrashMeta,
    DocumentText,
    SmartFolders,
    SyncAccounts,
    SyncState,
    ChangeLog,
    WatchDirs,
    WatchSuggestions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// v1: settings (M0). v2: catalog (M1). v3: FTS (M2). v4: sync (M5).
  /// v5: watch dirs (M7). v6: on-demand download state.
  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createFtsTable();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Catalog tables introduced in M1.
            await m.createTable(folders);
            await m.createTable(categories);
            await m.createTable(tags);
            await m.createTable(labels);
            await m.createTable(documents);
            await m.createTable(documentTags);
            await m.createTable(documentLabels);
            await m.createTable(trashMeta);
            await m.createTable(smartFolders);
          }
          if (from < 3) {
            // Full-text search introduced in M2.
            await m.createTable(documentText);
            await _createFtsTable();
          }
          if (from < 4) {
            // Sync bookkeeping introduced in M5.
            await m.createTable(syncAccounts);
            await m.createTable(syncState);
            await m.createTable(changeLog);
          }
          if (from < 5) {
            // Watch directories introduced in M7.
            await m.createTable(watchDirs);
            await m.createTable(watchSuggestions);
          }
          if (from < 6) {
            // On-demand download state. Existing rows default to 'local' so
            // every blob already on disk stays available. Guard against the
            // column already existing: some early databases ended up at
            // user_version 5 with this column present (schema/version overlap
            // during the v0.1→v0.2 transition), and a bare ADD COLUMN there
            // throws "duplicate column", bricking startup.
            if (!await _columnExists('documents', 'download_state')) {
              await m.addColumn(documents, documents.downloadState);
            }
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Whether [column] already exists on [table]. Used to make additive
  /// migrations idempotent against databases left in an inconsistent state.
  Future<bool> _columnExists(String table, String column) async {
    final rows = await customSelect(
      'SELECT 1 FROM pragma_table_info(?) WHERE name = ?',
      variables: [Variable.withString(table), Variable.withString(column)],
    ).get();
    return rows.isNotEmpty;
  }

  /// The FTS5 virtual table is created with raw SQL (drift has no table class
  /// for FTS5). Maintained by the search indexer; `uid` is stored but not
  /// indexed so we can map matches back to documents.
  Future<void> _createFtsTable() => customStatement(
        "CREATE VIRTUAL TABLE IF NOT EXISTS documents_fts "
        "USING fts5(uid UNINDEXED, title, body, "
        "tokenize = 'unicode61 remove_diacritics 2')",
      );

  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String? value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: key, value: Value(value)),
      );
}

/// Opens the on-disk catalog database under the OS app-support directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'paperdoc', 'catalog.sqlite'));
    await file.parent.create(recursive: true);
    return NativeDatabase.createInBackground(file);
  });
}

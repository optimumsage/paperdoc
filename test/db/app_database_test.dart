import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('settings key/value round-trip and upsert', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    expect(await db.getSetting('theme'), isNull);

    await db.setSetting('theme', 'dark');
    expect(await db.getSetting('theme'), 'dark');

    // Upsert overwrites rather than duplicating.
    await db.setSetting('theme', 'light');
    expect(await db.getSetting('theme'), 'light');
  });

  test('opening a v5 DB that already has download_state migrates without '
      'crashing on the duplicate column', () async {
    final dir = await Directory.systemTemp.createTemp('paperdoc_mig_');
    addTearDown(() => dir.delete(recursive: true));
    final path = p.join(dir.path, 'catalog.sqlite');

    // Reproduce the inconsistent state seen in the field: schema user_version
    // is 5, yet the documents table already carries the v6 download_state
    // column. A bare ADD COLUMN here throws "duplicate column" and bricks
    // startup; the migration must tolerate it.
    final raw = sqlite3.open(path);
    raw.execute('CREATE TABLE documents (id INTEGER PRIMARY KEY, '
        "download_state TEXT NOT NULL DEFAULT 'local');");
    raw.execute('PRAGMA user_version = 5;');
    raw.close();

    final db = AppDatabase(NativeDatabase(File(path)));
    addTearDown(db.close);

    // First query opens the connection and runs the migration — must not throw.
    final row =
        await db.customSelect('PRAGMA user_version').getSingle();
    expect(row.read<int>('user_version'), 6);
  });
}

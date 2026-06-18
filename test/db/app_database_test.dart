import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';

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
}

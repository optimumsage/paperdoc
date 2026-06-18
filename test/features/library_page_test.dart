import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/providers.dart';
import 'package:paperdoc/features/library/library_page.dart';

Widget _wrap(AppDatabase db) => ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: LibraryPage()),
    );

void main() {
  // The first-run gate is deterministic. The browser itself pulls in native
  // plugins (desktop_drop) and live drift streams, so it's verified by the
  // repository tests + on-device runs rather than a headless widget test.
  testWidgets('shows first-run setup when no library root is configured',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(_wrap(db));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to PaperDoc'), findsOneWidget);
    expect(find.text('Use default location'), findsOneWidget);
  });
}

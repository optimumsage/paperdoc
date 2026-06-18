import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/tag_repository.dart';

void main() {
  late AppDatabase db;
  late TagRepository tags;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tags = TagRepository(db);
  });

  tearDown(() => db.close());

  test('assign and unassign tags on a document (remove-wins tombstone)',
      () async {
    final work = await tags.create(name: 'Work');
    final urgent = await tags.create(name: 'Urgent');
    const docUid = 'doc-1';

    await tags.assign(docUid, work.uid);
    await tags.assign(docUid, urgent.uid);
    expect(
      (await tags.watchTagsForDocument(docUid).first).map((t) => t.name).toSet(),
      {'Work', 'Urgent'},
    );

    await tags.unassign(docUid, urgent.uid);
    expect(
      (await tags.watchTagsForDocument(docUid).first).map((t) => t.name),
      ['Work'],
    );
  });

  test('deleting a tag removes it from listings and documents', () async {
    final t = await tags.create(name: 'Temp');
    await tags.assign('doc-9', t.uid);

    await tags.softDelete(t.uid);
    expect(await tags.watchAll().first, isEmpty);
    expect(await tags.watchTagsForDocument('doc-9').first, isEmpty);
  });
}

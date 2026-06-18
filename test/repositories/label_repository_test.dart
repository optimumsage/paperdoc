import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/label_repository.dart';

void main() {
  late AppDatabase db;
  late LabelRepository labels;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    labels = LabelRepository(db);
  });

  tearDown(() => db.close());

  test('labels carry a kind and assign/unassign on documents', () async {
    final status = await labels.create(name: 'Final', kind: 'status');
    expect(status.kind, 'status');

    const docUid = 'doc-7';
    await labels.assign(docUid, status.uid);
    expect(
      (await labels.watchLabelsForDocument(docUid).first).map((l) => l.name),
      ['Final'],
    );

    await labels.unassign(docUid, status.uid);
    expect(await labels.watchLabelsForDocument(docUid).first, isEmpty);
  });

  test('deleting a label removes it from listings and documents', () async {
    final l = await labels.create(name: 'Priority', kind: 'priority');
    await labels.assign('doc-8', l.uid);

    await labels.softDelete(l.uid);
    expect(await labels.watchAll().first, isEmpty);
    expect(await labels.watchLabelsForDocument('doc-8').first, isEmpty);
  });
}

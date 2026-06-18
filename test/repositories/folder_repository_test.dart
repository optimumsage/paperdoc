import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/core/clock.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/document_repository.dart';
import 'package:paperdoc/data/repositories/folder_repository.dart';
import 'package:paperdoc/services/library/library_service.dart';
import 'package:path/path.dart' as p;

class _FakeClock implements Clock {
  const _FakeClock();
  @override
  int nowMs() => 1000;
}

void main() {
  late AppDatabase db;
  late FolderRepository folders;
  late DocumentRepository docs;
  late LibraryService library;
  late Directory tmp;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('paperdoc_folder_');
    library = LibraryService(db);
    await library.setRoot(p.join(tmp.path, 'library'));
    folders = FolderRepository(db, clock: _FakeClock());
    docs = DocumentRepository(db, library, clock: _FakeClock());
  });

  tearDown(() async {
    await db.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  test('create, rename and nest folders', () async {
    final personal = await folders.create(name: 'Personal');
    final taxes = await folders.create(name: 'Taxes', parentUid: personal.uid);

    expect((await folders.watchChildren(null).first).map((f) => f.uid),
        [personal.uid]);
    expect((await folders.watchChildren(personal.uid).first).map((f) => f.name),
        ['Taxes']);

    await folders.rename(taxes.uid, 'Tax Returns');
    expect((await folders.findByUid(taxes.uid))!.name, 'Tax Returns');
  });

  test('deleting a folder promotes children to its parent', () async {
    final root = await folders.create(name: 'Root');
    final mid = await folders.create(name: 'Mid', parentUid: root.uid);
    final leaf = await folders.create(name: 'Leaf', parentUid: mid.uid);

    final src = File(p.join(tmp.path, 'doc.txt'));
    await src.writeAsString('content');
    final doc = await docs.importFile(src.path, folderUid: mid.uid);

    await folders.softDelete(mid.uid);

    // Mid is gone; its child folder and document are reparented to Root.
    expect((await folders.findByUid(mid.uid))!.deleted, isTrue);
    expect((await folders.findByUid(leaf.uid))!.parentUid, root.uid);
    expect((await docs.findByUid(doc.uid))!.folderUid, root.uid);
  });
}

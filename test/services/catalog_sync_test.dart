import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/category_repository.dart';
import 'package:paperdoc/data/repositories/document_repository.dart';
import 'package:paperdoc/data/repositories/folder_repository.dart';
import 'package:paperdoc/data/repositories/tag_repository.dart';
import 'package:paperdoc/services/library/library_service.dart';
import 'package:paperdoc/services/sync/cloud_provider.dart';
import 'package:paperdoc/services/sync/sync_engine.dart';
import 'package:path/path.dart' as p;

class FakeCloud implements CloudProvider {
  final Map<String, ({String id, List<int> bytes, String hash})> files = {};

  @override
  String get name => 'fake';
  @override
  Future<String> ensureRoot() async => 'root';
  @override
  Future<List<RemoteFile>> listFiles() async => [
        for (final e in files.entries)
          RemoteFile(
              id: e.value.id,
              relPath: e.key,
              hash: e.value.hash,
              size: e.value.bytes.length),
      ];
  @override
  Future<void> download(RemoteFile file, String localPath) async {
    final out = File(localPath);
    await out.parent.create(recursive: true);
    await out.writeAsBytes(files[file.relPath]!.bytes);
  }

  @override
  Future<RemoteFile> upload({
    required String localPath,
    required String relPath,
    String? existingId,
  }) async {
    final bytes = await File(localPath).readAsBytes();
    final hash = sha256.convert(bytes).toString();
    files[relPath] = (id: relPath, bytes: bytes, hash: hash);
    return RemoteFile(
        id: relPath, relPath: relPath, hash: hash, size: bytes.length);
  }

  @override
  Future<void> delete(String id) async =>
      files.removeWhere((key, value) => value.id == id);
}

void main() {
  late FakeCloud cloud;
  late Directory tmp;

  setUp(() async {
    cloud = FakeCloud();
    tmp = await Directory.systemTemp.createTemp('paperdoc_catsync_');
  });
  tearDown(() => tmp.delete(recursive: true));

  Future<({AppDatabase db, LibraryService lib, SyncEngine engine, int acc})>
      device(String name) async {
    final db = AppDatabase(NativeDatabase.memory());
    final lib = LibraryService(db);
    await lib.setRoot(p.join(tmp.path, name));
    final engine = SyncEngine(db, lib, cloud);
    final acc = await db
        .into(db.syncAccounts)
        .insert(SyncAccountsCompanion.insert(provider: 'fake', accountId: 'me'));
    return (db: db, lib: lib, engine: engine, acc: acc);
  }

  test('folders, categories and tags travel with documents', () async {
    final a = await device('A');
    final docsA = DocumentRepository(a.db, a.lib);

    final folder = await FolderRepository(a.db).create(name: 'Taxes');
    final category = await CategoryRepository(a.db).create(name: 'Finance');
    final tag = await TagRepository(a.db).create(name: 'Important');

    final src = File(p.join(tmp.path, 'return.pdf'));
    await src.writeAsString('tax return');
    final doc = await docsA.importFile(src.path, folderUid: folder.uid);
    await docsA.setCategory(doc.uid, category.uid);
    await TagRepository(a.db).assign(doc.uid, tag.uid);

    await a.engine.sync(a.acc);

    // Device B pulls everything.
    final b = await device('B');
    await b.engine.sync(b.acc);
    final docsB = DocumentRepository(b.db, b.lib);

    final docB = await docsB.findByUid(doc.uid);
    expect(docB!.folderUid, folder.uid);
    expect(docB.categoryUid, category.uid);

    final folderB = await FolderRepository(b.db).findByUid(folder.uid);
    expect(folderB!.name, 'Taxes');
    final categoryB = await CategoryRepository(b.db).findByUid(category.uid);
    expect(categoryB!.name, 'Finance');
    final tagsForDoc =
        await TagRepository(b.db).watchTagsForDocument(doc.uid).first;
    expect(tagsForDoc.map((t) => t.name), ['Important']);

    // Rename the folder on A, re-sync → propagates to B (last-writer-wins).
    await FolderRepository(a.db).rename(folder.uid, 'Tax Returns');
    await a.engine.sync(a.acc);
    await b.engine.sync(b.acc);
    expect((await FolderRepository(b.db).findByUid(folder.uid))!.name,
        'Tax Returns');

    await a.db.close();
    await b.db.close();
  });

  test('moving an already-synced document to a folder propagates', () async {
    final a = await device('A');
    final docsA = DocumentRepository(a.db, a.lib);

    final src = File(p.join(tmp.path, 'memo.txt'));
    await src.writeAsString('memo body');
    final doc = await docsA.importFile(src.path); // unfiled
    await a.engine.sync(a.acc);

    final b = await device('B');
    await b.engine.sync(b.acc);
    final docsB = DocumentRepository(b.db, b.lib);
    expect((await docsB.findByUid(doc.uid))!.folderUid, isNull);

    // Move on A — metadata only, file bytes unchanged.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    final folder = await FolderRepository(a.db).create(name: 'Inbox');
    await docsA.moveToFolder(doc.uid, folder.uid);
    await a.engine.sync(a.acc);
    await b.engine.sync(b.acc);

    final docB = await docsB.findByUid(doc.uid);
    expect(docB!.folderUid, folder.uid);
    expect((await FolderRepository(b.db).findByUid(folder.uid))!.name, 'Inbox');

    await a.db.close();
    await b.db.close();
  });
}

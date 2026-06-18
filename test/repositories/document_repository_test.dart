import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/core/clock.dart';
import 'package:paperdoc/core/doc_type.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/document_repository.dart';
import 'package:paperdoc/services/library/library_service.dart';
import 'package:path/path.dart' as p;

class _FakeClock implements Clock {
  const _FakeClock();
  @override
  int nowMs() => 1000;
}

void main() {
  late AppDatabase db;
  late LibraryService library;
  late DocumentRepository repo;
  late Directory tmp;
  late _FakeClock clock;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('paperdoc_doc_');
    library = LibraryService(db);
    await library.setRoot(p.join(tmp.path, 'library'));
    clock = _FakeClock();
    repo = DocumentRepository(db, library, clock: clock);
  });

  tearDown(() async {
    await db.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  Future<File> makeSource(String name, String content) async {
    final f = File(p.join(tmp.path, name));
    await f.writeAsString(content);
    return f;
  }

  test('import copies the blob and records correct metadata', () async {
    const content = 'hello pdf content';
    final src = await makeSource('Invoice 2026.pdf', content);
    final expectedHash = sha256.convert(utf8.encode(content)).toString();

    final doc = await repo.importFile(src.path);

    expect(doc.title, 'Invoice 2026');
    expect(doc.originalName, 'Invoice 2026.pdf');
    expect(doc.ext, 'pdf');
    expect(doc.docType, DocType.pdf);
    expect(doc.contentHash, expectedHash);
    expect(doc.sizeBytes, content.length);
    expect(doc.relPath, startsWith('files/'));
    expect(doc.relPath.endsWith('.pdf'), isTrue);

    // Blob landed in the library; original preserved on copy.
    expect(await library.blobFile(doc.relPath).exists(), isTrue);
    expect(await src.exists(), isTrue);
  });

  test('import with move removes the original', () async {
    final src = await makeSource('scan.png', 'imgdata');
    final doc = await repo.importFile(src.path, move: true);

    expect(doc.docType, DocType.image);
    expect(await library.blobFile(doc.relPath).exists(), isTrue);
    expect(await src.exists(), isFalse);
  });

  test('rename updates title and bumps revision', () async {
    final src = await makeSource('a.txt', 'x');
    final doc = await repo.importFile(src.path);
    expect(doc.revision, 0);

    await repo.rename(doc.uid, 'Renamed');
    final updated = await repo.findByUid(doc.uid);
    expect(updated!.title, 'Renamed');
    expect(updated.revision, 1);
  });

  test('soft delete moves to trash; restore brings it back', () async {
    final src = await makeSource('b.txt', 'y');
    final doc = await repo.importFile(src.path, folderUid: 'folder-1');

    await repo.softDelete(doc.uid);
    expect((await repo.watchInFolder('folder-1').first), isEmpty);
    expect((await repo.watchTrash().first).map((d) => d.uid), [doc.uid]);

    await repo.restore(doc.uid);
    final restored = await repo.findByUid(doc.uid);
    expect(restored!.deleted, isFalse);
    expect(restored.folderUid, 'folder-1');
    expect((await repo.watchTrash().first), isEmpty);
  });

  test('copy duplicates blob and row with a new uid', () async {
    final src = await makeSource('c.pdf', 'pdfbytes');
    final doc = await repo.importFile(src.path);

    final copy = await repo.copyDocument(doc.uid);
    expect(copy.uid, isNot(doc.uid));
    expect(copy.contentHash, doc.contentHash);
    expect(copy.relPath, isNot(doc.relPath));
    expect(await library.blobFile(copy.relPath).exists(), isTrue);
    expect(await library.blobFile(doc.relPath).exists(), isTrue);
  });

  test('permanent delete removes blob and row', () async {
    final src = await makeSource('d.txt', 'z');
    final doc = await repo.importFile(src.path);
    final blob = library.blobFile(doc.relPath);

    await repo.permanentDelete(doc.uid);
    expect(await repo.findByUid(doc.uid), isNull);
    expect(await blob.exists(), isFalse);
  });

  test('detects exact-duplicate documents by content hash', () async {
    // Two files with identical content, one different.
    await repo.importFile((await makeSource('a.txt', 'same bytes')).path);
    await repo.importFile((await makeSource('b.txt', 'same bytes')).path);
    await repo.importFile((await makeSource('c.txt', 'different')).path);

    final groups = await repo.duplicateGroups();
    expect(groups.length, 1);
    expect(groups.first.length, 2);
    expect(
      groups.first.map((d) => d.title).toSet(),
      {'a', 'b'},
    );
  });

  test('sort by name and size', () async {
    await repo.importFile((await makeSource('banana.txt', 'xx')).path);
    await repo.importFile((await makeSource('apple.txt', 'xxxxx')).path);
    await repo.importFile((await makeSource('cherry.txt', 'x')).path);

    final byName =
        await repo.watchAll(sort: DocumentSort.nameAsc).first;
    expect(byName.map((d) => d.title), ['apple', 'banana', 'cherry']);

    final bySize =
        await repo.watchAll(sort: DocumentSort.sizeDesc).first;
    expect(bySize.map((d) => d.title), ['apple', 'banana', 'cherry']);
  });

  test('bulk move and bulk delete operate on many documents', () async {
    final a = await repo.importFile((await makeSource('1.txt', 'a')).path);
    final b = await repo.importFile((await makeSource('2.txt', 'b')).path);
    final c = await repo.importFile((await makeSource('3.txt', 'c')).path);

    await repo.bulkMoveToFolder([a.uid, b.uid], 'folder-x');
    expect((await repo.findByUid(a.uid))!.folderUid, 'folder-x');
    expect((await repo.findByUid(b.uid))!.folderUid, 'folder-x');
    expect((await repo.findByUid(c.uid))!.folderUid, isNull);

    await repo.bulkSoftDelete([a.uid, b.uid, c.uid]);
    expect(await repo.watchAll().first, isEmpty);
    expect((await repo.watchTrash().first).length, 3);

    await repo.bulkRestore([a.uid]);
    expect((await repo.watchAll().first).map((d) => d.uid), [a.uid]);
  });

  test('set category and watchByUid reflects later edits', () async {
    final src = await makeSource('e.pdf', 'data');
    final doc = await repo.importFile(src.path);

    await repo.setCategory(doc.uid, 'cat-1');
    expect((await repo.findByUid(doc.uid))!.categoryUid, 'cat-1');

    await repo.rename(doc.uid, 'New Title');
    expect((await repo.watchByUid(doc.uid).first)!.title, 'New Title');
  });

  test('imported documents are local by default', () async {
    final src = await makeSource('f.pdf', 'data');
    final doc = await repo.importFile(src.path);
    expect(doc.downloadState, 'local');
  });

  test('freeUpSpace requires a remote backup', () async {
    final src = await makeSource('g.pdf', 'data');
    final doc = await repo.importFile(src.path);

    // Not backed up to any cloud → must not delete the only copy.
    expect(await repo.freeUpSpace(doc.uid), isFalse);
    expect(library.blobFile(doc.relPath).existsSync(), isTrue);
    expect((await repo.findByUid(doc.uid))!.downloadState, 'local');

    // Record a remote copy, then free space → blob removed, becomes cloud-only.
    final accId = await db.into(db.syncAccounts).insert(
        SyncAccountsCompanion.insert(provider: 'fake', accountId: 'me'));
    await db.into(db.syncState).insert(SyncStateCompanion.insert(
        accountId: accId,
        relPath: doc.relPath,
        remoteId: const Value('remote-1')));

    expect(await repo.freeUpSpace(doc.uid), isTrue);
    expect(library.blobFile(doc.relPath).existsSync(), isFalse);
    expect((await repo.findByUid(doc.uid))!.downloadState, 'cloud');
  });
}

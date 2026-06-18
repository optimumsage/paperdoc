import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/document_repository.dart';
import 'package:paperdoc/services/library/library_service.dart';
import 'package:paperdoc/services/sync/cloud_provider.dart';
import 'package:paperdoc/services/sync/sync_engine.dart';
import 'package:path/path.dart' as p;

/// In-memory cloud keyed by rel path; the file id is the rel path itself.
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
            size: e.value.bytes.length,
          ),
      ];

  @override
  Future<void> download(RemoteFile file, String localPath) async {
    final entry = files[file.relPath]!;
    final out = File(localPath);
    await out.parent.create(recursive: true);
    await out.writeAsBytes(entry.bytes);
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

class _Device {
  _Device(this.db, this.library, this.repo, this.engine, this.accountId);
  final AppDatabase db;
  final LibraryService library;
  final DocumentRepository repo;
  final SyncEngine engine;
  final int accountId;
}

void main() {
  late FakeCloud cloud;
  late Directory tmp;

  setUp(() async {
    cloud = FakeCloud();
    tmp = await Directory.systemTemp.createTemp('paperdoc_synctest_');
  });

  tearDown(() async {
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  Future<_Device> device(String name) async {
    final db = AppDatabase(NativeDatabase.memory());
    final library = LibraryService(db);
    await library.setRoot(p.join(tmp.path, name));
    final repo = DocumentRepository(db, library);
    final engine = SyncEngine(db, library, cloud);
    final accountId = await db.into(db.syncAccounts).insert(
          SyncAccountsCompanion.insert(provider: 'fake', accountId: 'me'),
        );
    return _Device(db, library, repo, engine, accountId);
  }

  Future<void> editContent(_Device d, String uid, String content) async {
    final doc =
        await (d.db.select(d.db.documents)..where((t) => t.uid.equals(uid)))
            .getSingle();
    await d.library.blobFile(doc.relPath).writeAsString(content);
    await (d.db.update(d.db.documents)..where((t) => t.uid.equals(uid)))
        .write(DocumentsCompanion(
      contentHash: Value(sha256.convert(utf8.encode(content)).toString()),
    ));
  }

  test('push from one device, pull on another', () async {
    final a = await device('A');
    final b = await device('B');

    final srcFile = File(p.join(tmp.path, 'note.txt'));
    await srcFile.writeAsString('shared content');
    final docA = await a.repo.importFile(srcFile.path);

    await a.engine.sync(a.accountId);
    final report = await b.engine.sync(b.accountId);

    expect(report.downloaded, 1);
    final docB = await b.repo.findByUid(docA.uid);
    expect(docB, isNotNull);
    expect(docB!.title, 'note');
    expect(await b.library.blobFile(docB.relPath).readAsString(),
        'shared content');

    await a.db.close();
    await b.db.close();
  });

  test('permanent delete on one device propagates to the other', () async {
    final a = await device('A');
    final b = await device('B');

    final src = File(p.join(tmp.path, 'x.txt'));
    await src.writeAsString('to be deleted');
    final doc = await a.repo.importFile(src.path);

    await a.engine.sync(a.accountId);
    await b.engine.sync(b.accountId);
    expect(await b.repo.findByUid(doc.uid), isNotNull);

    await a.repo.permanentDelete(doc.uid);
    await a.engine.sync(a.accountId); // deletes remote
    await b.engine.sync(b.accountId); // deletes local

    expect(await b.repo.findByUid(doc.uid), isNull);

    await a.db.close();
    await b.db.close();
  });

  test('divergent edits produce a keep-both conflict', () async {
    final a = await device('A');
    final b = await device('B');

    final src = File(p.join(tmp.path, 'doc.txt'));
    await src.writeAsString('v0');
    final doc = await a.repo.importFile(src.path);

    // Both devices in sync at v0.
    await a.engine.sync(a.accountId);
    await b.engine.sync(b.accountId);

    // Each edits the same document differently.
    await editContent(a, doc.uid, 'A version');
    await a.engine.sync(a.accountId); // remote now = A version

    await editContent(b, doc.uid, 'B version');
    final report = await b.engine.sync(b.accountId);

    expect(report.conflicts, 1);
    // B keeps its own version plus a downloaded "(conflict)" copy.
    final all = await b.repo.watchAll().first;
    expect(all.length, 2);
    final titles = all.map((d) => d.title).toList();
    expect(titles.any((t) => t.contains('conflict')), isTrue);

    // No data lost: both versions present on B.
    final contents = <String>[];
    for (final d in all) {
      contents.add(await b.library.blobFile(d.relPath).readAsString());
    }
    expect(contents.toSet(), {'A version', 'B version'});

    await a.db.close();
    await b.db.close();
  });
}

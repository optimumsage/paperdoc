import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/document_repository.dart';
import 'package:paperdoc/data/repositories/watch_dir_repository.dart';
import 'package:paperdoc/services/library/library_service.dart';
import 'package:paperdoc/services/watch/watch_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late AppDatabase db;
  late WatchService watch;
  late WatchDirRepository dirs;
  late Directory tmp;
  late Directory watched;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    watch = WatchService(db);
    dirs = WatchDirRepository(db);
    tmp = await Directory.systemTemp.createTemp('paperdoc_watch_');
    watched = Directory(p.join(tmp.path, 'downloads'));
    await watched.create(recursive: true);
  });

  tearDown(() async {
    await db.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  Future<int> pendingCount() async =>
      (await (db.select(db.watchSuggestions)
                ..where((t) => t.status.equals('pending')))
              .get())
          .length;

  test('scan suggests new document files and dedupes on re-scan', () async {
    await File(p.join(watched.path, 'invoice.pdf')).writeAsString('pdf');
    await File(p.join(watched.path, 'notes.txt')).writeAsString('text');
    await File(p.join(watched.path, 'image.jpg')).writeAsString('img');
    await File(p.join(watched.path, 'ignore.bin')).writeAsString('binary');

    final dir = await dirs.add(path: watched.path);

    final created = await watch.scanDir(dir);
    expect(created, 3); // pdf, txt, jpg — not the .bin
    expect(await pendingCount(), 3);

    // Re-scan: nothing new.
    expect(await watch.scanDir(dir), 0);
    expect(await pendingCount(), 3);
  });

  test('files already in the library are not suggested', () async {
    final library = LibraryService(db);
    await library.setRoot(p.join(tmp.path, 'library'));
    final repo = DocumentRepository(db, library);

    final f = File(p.join(watched.path, 'already.pdf'));
    await f.writeAsString('same-content');
    await repo.importFile(f.path); // now in the library by content hash

    final dir = await dirs.add(path: watched.path);
    expect(await watch.scanDir(dir), 0);
    expect(await pendingCount(), 0);
  });
}

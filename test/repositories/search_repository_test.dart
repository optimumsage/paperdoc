import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/core/doc_type.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/models/search_query.dart';
import 'package:paperdoc/data/repositories/document_repository.dart';
import 'package:paperdoc/data/repositories/search_repository.dart';
import 'package:paperdoc/data/repositories/tag_repository.dart';
import 'package:paperdoc/services/library/library_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late AppDatabase db;
  late DocumentRepository docs;
  late SearchRepository search;
  late TagRepository tags;
  late LibraryService library;
  late Directory tmp;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('paperdoc_search_');
    library = LibraryService(db);
    await library.setRoot(p.join(tmp.path, 'library'));
    docs = DocumentRepository(db, library);
    search = SearchRepository(db);
    tags = TagRepository(db);
  });

  tearDown(() async {
    await db.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  Future<File> src(String name, String content) async {
    final f = File(p.join(tmp.path, name));
    await f.writeAsString(content);
    return f;
  }

  test('full-text search matches body and title, with prefix', () async {
    await docs.importFile((await src('report.txt', 'annual revenue 2026')).path);
    await docs.importFile((await src('Invoice.pdf', '%PDF-1.7 binary')).path);

    expect(
      (await search.search(const SearchQuery(text: 'revenue')))
          .map((d) => d.title),
      ['report'],
    );
    // Prefix match.
    expect(
      (await search.search(const SearchQuery(text: 'rev')))
          .map((d) => d.title),
      ['report'],
    );
    // Title match (PDF body isn't extracted yet, but the name is indexed).
    expect(
      (await search.search(const SearchQuery(text: 'invoice')))
          .map((d) => d.title),
      ['Invoice'],
    );
    expect(await search.search(const SearchQuery(text: 'zzz')), isEmpty);
  });

  test('facet filters by type and tag', () async {
    final txt = await docs.importFile((await src('a.txt', 'hello world')).path);
    final pdf = await docs.importFile((await src('b.pdf', 'pdf')).path);

    expect(
      (await search.search(const SearchQuery(docTypes: {DocType.pdf})))
          .map((d) => d.uid),
      [pdf.uid],
    );

    final work = await tags.create(name: 'Work');
    await tags.assign(txt.uid, work.uid);
    expect(
      (await search.search(SearchQuery(tagUids: {work.uid})))
          .map((d) => d.uid),
      [txt.uid],
    );
  });

  test('renaming reindexes the document for search', () async {
    final doc =
        await docs.importFile((await src('memo.txt', 'plain body')).path);
    await docs.rename(doc.uid, 'Quarterly Strategy');

    expect(
      (await search.search(const SearchQuery(text: 'strategy')))
          .map((d) => d.uid),
      [doc.uid],
    );
  });

  test('search query round-trips through JSON', () {
    const q = SearchQuery(
      text: 'x',
      docTypes: {'pdf', 'image'},
      tagUids: {'t1'},
      categoryUid: 'c1',
      createdFromMs: 100,
      createdToMs: 200,
    );
    expect(SearchQuery.fromJson(q.toJson()), q);
  });
}

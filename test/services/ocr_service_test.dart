import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/models/search_query.dart';
import 'package:paperdoc/data/repositories/document_repository.dart';
import 'package:paperdoc/data/repositories/search_repository.dart';
import 'package:paperdoc/services/library/library_service.dart';
import 'package:paperdoc/services/ocr/ocr_engine.dart';
import 'package:paperdoc/services/ocr/ocr_service.dart';
import 'package:paperdoc/services/ocr/pdf_renderer.dart';
import 'package:paperdoc/services/search/search_indexer.dart';
import 'package:paperdoc/services/security/crypto_service.dart';
import 'package:paperdoc/services/security/library_encryption.dart';
import 'package:path/path.dart' as p;

const _fastKdf = KdfParams(
  salt: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
  memory: 256,
  iterations: 1,
  parallelism: 1,
  hashLength: 32,
);

class _FakeOcrEngine implements OcrEngine {
  _FakeOcrEngine(this.text, {this.available = true});
  final String text;
  final bool available;

  @override
  String get name => 'fake';
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<OcrResult?> recognizeImage(String imagePath) async =>
      OcrResult(text: text, engine: 'fake');
  @override
  Future<void> dispose() async {}
}

/// Returns two fake page paths without touching pdfium.
class _FakePdfRenderer implements PdfRenderer {
  @override
  Future<List<String>> renderToImages(String pdfPath, String destDir,
          {int maxPages = 30}) async =>
      [p.join(destDir, 'page_0.png'), p.join(destDir, 'page_1.png')];
}

/// Recognizes text per page (uses the page filename as a marker).
class _PerPageEngine implements OcrEngine {
  @override
  String get name => 'fakepdf';
  @override
  Future<bool> isAvailable() async => true;
  @override
  Future<OcrResult?> recognizeImage(String imagePath) async =>
      OcrResult(text: 'invoice ${p.basenameWithoutExtension(imagePath)}');
  @override
  Future<void> dispose() async {}
}

void main() {
  late AppDatabase db;
  late LibraryService library;
  late DocumentRepository docs;
  late SearchRepository search;
  late Directory tmp;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('paperdoc_ocr_');
    library = LibraryService(db);
    await library.setRoot(p.join(tmp.path, 'library'));
    docs = DocumentRepository(db, library);
    search = SearchRepository(db);
  });

  tearDown(() async {
    await db.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  Future<String> importImage() async {
    final f = File(p.join(tmp.path, 'scan.png'));
    await f.writeAsBytes([0x89, 0x50, 0x4E, 0x47]); // fake PNG header
    final doc = await docs.importFile(f.path);
    return doc.uid;
  }

  test('imported images are queued for OCR', () async {
    final uid = await importImage();
    expect((await docs.findByUid(uid))!.ocrStatus, OcrStatus.pending);
  });

  test('OCR populates text, marks done, and makes the image searchable',
      () async {
    final uid = await importImage();
    final service = OcrService(
      db,
      library,
      _FakeOcrEngine('Invoice total 4200 USD'),
      SearchIndexer(db),
    );

    await service.processPending();

    expect((await docs.findByUid(uid))!.ocrStatus, OcrStatus.done);
    final results =
        await search.search(const SearchQuery(text: 'invoice'));
    expect(results.map((d) => d.uid), [uid]);
  });

  test('unavailable engine marks the document failed', () async {
    final uid = await importImage();
    final service = OcrService(
      db,
      library,
      _FakeOcrEngine('', available: false),
      SearchIndexer(db),
    );

    await service.processPending();
    expect((await docs.findByUid(uid))!.ocrStatus, OcrStatus.failed);
  });

  test('scanned PDF OCR renders pages, combines text, and indexes it',
      () async {
    // A PDF with no extractable text layer → queued for OCR.
    final f = File(p.join(tmp.path, 'scan.pdf'));
    await f.writeAsBytes([0x25, 0x50, 0x44, 0x46]); // '%PDF' but not parseable
    final doc = await docs.importFile(f.path);
    expect(doc.ocrStatus, OcrStatus.pending);

    final service = OcrService(
      db,
      library,
      _PerPageEngine(),
      SearchIndexer(db),
      renderer: _FakePdfRenderer(),
    );
    await service.processPending();

    expect((await docs.findByUid(doc.uid))!.ocrStatus, OcrStatus.done);
    // Both rendered pages contributed to the combined OCR text.
    final textRow = await (db.select(db.documentText)
          ..where((t) => t.documentUid.equals(doc.uid)))
        .getSingleOrNull();
    expect(textRow!.content, contains('page_0'));
    expect(textRow.content, contains('page_1'));
    // And it's searchable.
    final results = await search.search(const SearchQuery(text: 'invoice'));
    expect(results.map((d) => d.uid), [doc.uid]);
  });

  test('OCR decrypts and processes encrypted images when unlocked', () async {
    final encryption = LibraryEncryption(db);
    await encryption.enable('pw', params: _fastKdf);
    final encDocs = DocumentRepository(db, library, encryption: encryption);

    final f = File(p.join(tmp.path, 'enc.png'));
    await f.writeAsBytes([0x89, 0x50, 0x4E, 0x47]);
    final doc = await encDocs.importFile(f.path);
    expect(doc.isEncrypted, isTrue);
    expect(doc.ocrStatus, OcrStatus.pending);

    final service = OcrService(
      db,
      library,
      _FakeOcrEngine('secret scanned text'),
      SearchIndexer(db),
      encryption: encryption,
    );
    await service.processPending();

    expect((await encDocs.findByUid(doc.uid))!.ocrStatus, OcrStatus.done);
    final results = await search.search(const SearchQuery(text: 'secret'));
    expect(results.map((d) => d.uid), [doc.uid]);
  });

  test('encrypted documents are skipped while the library is locked', () async {
    final encryption = LibraryEncryption(db);
    await encryption.enable('pw', params: _fastKdf);
    final encDocs = DocumentRepository(db, library, encryption: encryption);

    final f = File(p.join(tmp.path, 'enc2.png'));
    await f.writeAsBytes([0x89, 0x50, 0x4E, 0x47]);
    final doc = await encDocs.importFile(f.path);

    encryption.lock();
    final service = OcrService(
      db,
      library,
      _FakeOcrEngine('x'),
      SearchIndexer(db),
      encryption: encryption,
    );
    await service.processPending();

    // Left pending (not failed) so it processes after unlock.
    expect((await encDocs.findByUid(doc.uid))!.ocrStatus, OcrStatus.pending);
  });
}

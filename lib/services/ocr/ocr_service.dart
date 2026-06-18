import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../core/clock.dart';
import '../../core/doc_type.dart';
import '../../data/db/app_database.dart';
import '../library/library_service.dart';
import '../security/library_encryption.dart';
import '../search/search_indexer.dart';
import 'ocr_engine.dart';
import 'pdf_renderer.dart';

/// OCR status values stored on `documents.ocrStatus`.
abstract final class OcrStatus {
  static const none = 'none';
  static const notNeeded = 'not_needed';
  static const pending = 'pending';
  static const running = 'running';
  static const done = 'done';
  static const failed = 'failed';
}

/// Runs OCR over documents marked `pending`, stores the recognized text, and
/// feeds it into the search index. Processing is sequential and guarded so it
/// never runs twice concurrently. The engine calls are already off the UI
/// thread (ML Kit is native-async; Tesseract runs as a subprocess).
class OcrService {
  OcrService(
    this._db,
    this._library,
    this._engine,
    this._indexer, {
    Clock clock = const SystemClock(),
    PdfRenderer renderer = const PrintingPdfRenderer(),
    LibraryEncryption? encryption,
  })  : _clock = clock,
        _renderer = renderer,
        _encryption = encryption;

  final AppDatabase _db;
  final LibraryService _library;
  final OcrEngine _engine;
  final SearchIndexer _indexer;
  final Clock _clock;
  final PdfRenderer _renderer;
  final LibraryEncryption? _encryption;

  bool _running = false;

  bool get _canDecrypt => _encryption?.isUnlocked ?? false;

  /// Processes every pending document, one at a time. Safe to call repeatedly.
  /// Encrypted documents are skipped while the library is locked (so the loop
  /// doesn't spin); they'll be picked up after unlock when this runs again.
  Future<void> processPending() async {
    if (_running) return;
    _running = true;
    try {
      while (true) {
        final next = await (_db.select(_db.documents)
              ..where((t) {
                var cond = t.ocrStatus.equals(OcrStatus.pending) &
                    t.deleted.equals(false) &
                    // Cloud-only placeholders have no local blob to OCR.
                    t.downloadState.equals('local');
                if (!_canDecrypt) cond = cond & t.isEncrypted.equals(false);
                return cond;
              })
              ..limit(1))
            .getSingleOrNull();
        if (next == null) break;
        await _process(next);
      }
    } finally {
      _running = false;
    }
  }

  /// Re-queues a single document and processes it (e.g. user taps "Run OCR").
  Future<void> requestOcr(String uid) async {
    await _setStatus(uid, OcrStatus.pending);
    await processPending();
  }

  Future<void> _process(Document doc) async {
    await _setStatus(doc.uid, OcrStatus.running);

    if (!await _engine.isAvailable()) {
      await _setStatus(doc.uid, OcrStatus.failed);
      return;
    }

    // For encrypted blobs, decrypt to a temp plaintext file first.
    Directory? tempDir;
    final String text;
    try {
      String workingPath;
      if (doc.isEncrypted) {
        final encryption = _encryption;
        if (encryption == null || !encryption.isUnlocked) {
          await _setStatus(doc.uid, OcrStatus.pending);
          return;
        }
        tempDir = await Directory.systemTemp.createTemp('paperdoc_ocrdec_');
        final cipher =
            await _library.blobFile(doc.relPath).readAsBytes();
        final plain = await encryption.decrypt(cipher);
        final dec = File(p.join(tempDir.path, 'dec.${doc.ext ?? 'bin'}'));
        await dec.writeAsBytes(plain);
        workingPath = dec.path;
      } else {
        workingPath = await _library.blobAbsolutePath(doc.relPath);
      }

      if (doc.docType == DocType.pdf) {
        text = await _ocrPdf(workingPath);
      } else {
        final result = await _engine.recognizeImage(workingPath);
        if (result == null) {
          await _setStatus(doc.uid, OcrStatus.failed);
          return;
        }
        text = result.text.trim();
      }
    } catch (_) {
      await _setStatus(doc.uid, OcrStatus.failed);
      return;
    } finally {
      if (tempDir != null && tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    }

    if (text.isNotEmpty) {
      await _db.into(_db.documentText).insertOnConflictUpdate(
            DocumentTextCompanion.insert(
              documentUid: doc.uid,
              source: 'ocr',
              extractedAt: _clock.nowMs(),
              content: Value(text),
              charCount: Value(text.length),
              engine: Value(_engine.name),
            ),
          );
      await _indexer.index(uid: doc.uid, title: doc.title, body: text);
    }
    await _setStatus(doc.uid, OcrStatus.done);
  }

  /// Renders a scanned PDF's pages to images and OCRs each, combining the text.
  Future<String> _ocrPdf(String pdfPath) async {
    final tmpDir = await Directory.systemTemp.createTemp('paperdoc_ocrpdf_');
    try {
      final pages = await _renderer.renderToImages(pdfPath, tmpDir.path);
      final buffer = StringBuffer();
      for (final page in pages) {
        final result = await _engine.recognizeImage(page);
        final pageText = result?.text.trim() ?? '';
        if (pageText.isNotEmpty) {
          buffer
            ..write(pageText)
            ..write('\n');
        }
      }
      return buffer.toString().trim();
    } finally {
      if (tmpDir.existsSync()) await tmpDir.delete(recursive: true);
    }
  }

  Future<void> _setStatus(String uid, String status) =>
      (_db.update(_db.documents)..where((t) => t.uid.equals(uid))).write(
        DocumentsCompanion(
          ocrStatus: Value(status),
          updatedAt: Value(_clock.nowMs()),
        ),
      );
}

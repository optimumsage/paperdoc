import 'dart:io';

import 'ocr_engine.dart';

/// Desktop OCR via the Tesseract command-line tool (e.g. `brew install
/// tesseract`). Avoids bundling native libraries for now; if the binary isn't
/// installed, [isAvailable] reports false and the app degrades gracefully.
/// A bundled libtesseract FFI implementation can replace this later.
class TesseractCliEngine implements OcrEngine {
  const TesseractCliEngine({this.executable = 'tesseract', this.language = 'eng'});

  final String executable;
  final String language;

  @override
  String get name => 'tesseract';

  @override
  Future<bool> isAvailable() async {
    try {
      final result = await Process.run(executable, ['--version']);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<OcrResult?> recognizeImage(String imagePath) async {
    try {
      final result = await Process.run(
        executable,
        [imagePath, 'stdout', '-l', language],
      );
      if (result.exitCode != 0) return null;
      return OcrResult(
        text: (result.stdout as String).trim(),
        engine: 'tesseract',
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> dispose() async {}
}

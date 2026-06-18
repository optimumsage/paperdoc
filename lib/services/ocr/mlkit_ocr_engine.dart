import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'ocr_engine.dart';

/// On-device OCR for Android via Google ML Kit. Instantiated only on Android
/// (see [createOcrEngine]); the import compiles on all platforms but the native
/// side ships only on Android.
class MlKitOcrEngine implements OcrEngine {
  MlKitOcrEngine()
      : _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final TextRecognizer _recognizer;

  @override
  String get name => 'mlkit';

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<OcrResult?> recognizeImage(String imagePath) async {
    try {
      final input = InputImage.fromFilePath(imagePath);
      final recognized = await _recognizer.processImage(input);
      return OcrResult(text: recognized.text.trim(), engine: 'mlkit');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> dispose() => _recognizer.close();
}

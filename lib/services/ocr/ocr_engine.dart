/// Result of recognizing text in an image.
class OcrResult {
  const OcrResult({required this.text, this.confidence, this.engine});

  final String text;
  final double? confidence;
  final String? engine;
}

/// Platform-agnostic OCR contract. Implementations: ML Kit on Android, Tesseract
/// on desktop, and a no-op fallback where neither is available. The rest of the
/// app depends only on this interface (see [createOcrEngine]).
abstract interface class OcrEngine {
  String get name;

  /// Whether this engine can actually run in the current environment.
  Future<bool> isAvailable();

  /// Recognizes text in [imagePath]. Returns null on failure; an empty-string
  /// result means "ran successfully but found no text".
  Future<OcrResult?> recognizeImage(String imagePath);

  /// Releases any native resources.
  Future<void> dispose();
}

/// Used when no OCR engine is available for the platform (e.g. desktop without
/// Tesseract installed). Always reports unavailable.
class NoopOcrEngine implements OcrEngine {
  const NoopOcrEngine();

  @override
  String get name => 'none';

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<OcrResult?> recognizeImage(String imagePath) async => null;

  @override
  Future<void> dispose() async {}
}

import '../../core/platform_info.dart';
import 'mlkit_ocr_engine.dart';
import 'ocr_engine.dart';
import 'tesseract_cli_engine.dart';

/// Picks the right OCR engine for the current platform: ML Kit on Android,
/// Tesseract CLI on desktop, and a no-op fallback elsewhere.
OcrEngine createOcrEngine() {
  if (PlatformInfo.isAndroid) return MlKitOcrEngine();
  if (PlatformInfo.isDesktop) return const TesseractCliEngine();
  return const NoopOcrEngine();
}

import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

import 'doc_scanner.dart';

/// Android document scanner backed by ML Kit. Produces a multi-page PDF with
/// automatic edge detection, cropping, and enhancement. Instantiated only on
/// Android (see [createDocScanner]).
class MlKitDocScanner implements DocScanner {
  @override
  bool get isSupported => true;

  @override
  Future<List<String>> scan() async {
    final scanner = DocumentScanner(
      options: DocumentScannerOptions(
        documentFormats: const {DocumentFormat.pdf},
        mode: ScannerMode.full,
        pageLimit: 30,
        isGalleryImport: true,
      ),
    );
    try {
      final result = await scanner.scanDocument();
      final pdf = result.pdf;
      if (pdf != null) return [_toPath(pdf.uri)];
      return [
        for (final image in result.images ?? const <String>[]) _toPath(image),
      ];
    } on Exception {
      // Cancelled or failed — treat as "no scan".
      return const [];
    } finally {
      await scanner.close();
    }
  }

  String _toPath(String uriOrPath) {
    if (uriOrPath.startsWith('file://')) {
      try {
        return Uri.parse(uriOrPath).toFilePath();
      } catch (_) {
        // fall through
      }
    }
    return uriOrPath;
  }
}

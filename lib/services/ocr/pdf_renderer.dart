import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';

/// Renders PDF pages to images so scanned (image-only) PDFs can be OCR'd.
/// Behind an interface so the OCR pipeline can be tested with a fake renderer.
abstract interface class PdfRenderer {
  Future<List<String>> renderToImages(
    String pdfPath,
    String destDir, {
    int maxPages,
  });
}

/// Rasterizes pages with the `printing` package (pdfium under the hood).
class PrintingPdfRenderer implements PdfRenderer {
  const PrintingPdfRenderer({this.dpi = 150});

  final double dpi;

  @override
  Future<List<String>> renderToImages(
    String pdfPath,
    String destDir, {
    int maxPages = 30,
  }) async {
    final bytes = await File(pdfPath).readAsBytes();
    await Directory(destDir).create(recursive: true);
    final paths = <String>[];
    var index = 0;
    await for (final page in Printing.raster(bytes, dpi: dpi)) {
      final png = await page.toPng();
      final out = File(p.join(destDir, 'page_$index.png'));
      await out.writeAsBytes(png);
      paths.add(out.path);
      index++;
      if (index >= maxPages) break;
    }
    return paths;
  }
}

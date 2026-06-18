import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/core/doc_type.dart';
import 'package:paperdoc/services/search/text_extractor.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  late Directory tmp;
  final extractor = const TextExtractor();

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('paperdoc_extract_');
  });
  tearDown(() => tmp.delete(recursive: true));

  Future<File> zipFile(String name, Map<String, String> entries) async {
    final archive = Archive();
    entries.forEach((path, content) {
      archive.addFile(ArchiveFile.typedData(
          path, Uint8List.fromList(utf8.encode(content))));
    });
    final f = File(p.join(tmp.path, name));
    await f.writeAsBytes(ZipEncoder().encodeBytes(archive));
    return f;
  }

  test('extracts text from a .docx', () async {
    final docx = await zipFile('memo.docx', {
      'word/document.xml':
          '<w:document><w:body><w:p><w:r><w:t>Quarterly</w:t></w:r>'
              '<w:r><w:t xml:space="preserve"> revenue report</w:t></w:r>'
              '</w:p></w:body></w:document>',
    });

    final result =
        await extractor.extract(file: docx, docType: DocType.office, ext: 'docx');
    expect(result, isNotNull);
    expect(result!.source, 'office');
    expect(result.content, contains('Quarterly'));
    expect(result.content, contains('revenue report'));
  });

  test('extracts shared strings from an .xlsx', () async {
    final xlsx = await zipFile('budget.xlsx', {
      'xl/sharedStrings.xml':
          '<sst><si><t>Marketing Budget</t></si><si><t>2026</t></si></sst>',
    });

    final result =
        await extractor.extract(file: xlsx, docType: DocType.office, ext: 'xlsx');
    expect(result!.content, contains('Marketing Budget'));
    expect(result.content, contains('2026'));
  });

  test('extracts the text layer from a PDF', () async {
    final document = PdfDocument();
    document.pages.add().graphics.drawString(
          'Confidential invoice 4200 USD',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
        );
    final bytes = await document.save();
    document.dispose();
    final pdf = File(p.join(tmp.path, 'invoice.pdf'));
    await pdf.writeAsBytes(bytes);

    final result =
        await extractor.extract(file: pdf, docType: DocType.pdf, ext: 'pdf');
    expect(result, isNotNull);
    expect(result!.source, 'text_layer');
    expect(result.content, contains('invoice'));
  });
}

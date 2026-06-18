import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../core/doc_type.dart';

class ExtractedText {
  const ExtractedText({required this.source, required this.content});

  /// plain | text_layer | office | ocr
  final String source;
  final String content;
}

/// Pulls indexable plaintext out of a document for full-text search:
///   * text files (txt/md/csv/json/xml/html…),
///   * PDF text layers (digital PDFs — scanned PDFs with no text fall back to
///     name/tag search until PDF-OCR lands),
///   * Office files (docx / xlsx / pptx) via their internal XML.
///
/// PDF and Office extraction run on a background isolate so importing stays
/// responsive.
class TextExtractor {
  const TextExtractor({this.maxChars = 1000000});

  /// Cap so a huge document doesn't bloat the index.
  final int maxChars;

  Future<ExtractedText?> extract({
    required File file,
    required String docType,
    String? ext,
  }) async {
    switch (docType) {
      case DocType.text:
        return _extractPlain(file);
      case DocType.pdf:
        return _extractPdf(file);
      case DocType.office:
        return _extractOffice(file, ext);
      default:
        return null;
    }
  }

  Future<ExtractedText?> _extractPlain(File file) async {
    final bytes = await _readCapped(file, 2 * 1024 * 1024);
    final text = utf8.decode(bytes, allowMalformed: true).trim();
    if (text.isEmpty) return null;
    return ExtractedText(source: 'plain', content: text);
  }

  Future<ExtractedText?> _extractPdf(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final text = await Isolate.run(() {
        final document = PdfDocument(inputBytes: bytes);
        final extracted = PdfTextExtractor(document).extractText();
        document.dispose();
        return extracted;
      });
      final trimmed = text.trim();
      if (trimmed.isEmpty) return null; // likely scanned → OCR follow-up
      return ExtractedText(source: 'text_layer', content: _cap(trimmed));
    } catch (_) {
      return null;
    }
  }

  Future<ExtractedText?> _extractOffice(File file, String? ext) async {
    final kind = (ext ?? '').toLowerCase();
    if (!{'docx', 'xlsx', 'pptx'}.contains(kind)) return null;
    try {
      final bytes = await file.readAsBytes();
      final text = await Isolate.run(() => _officeText(bytes, kind));
      final trimmed = text.trim();
      if (trimmed.isEmpty) return null;
      return ExtractedText(source: 'office', content: _cap(trimmed));
    } catch (_) {
      return null;
    }
  }

  String _cap(String s) => s.length > maxChars ? s.substring(0, maxChars) : s;

  Future<List<int>> _readCapped(File file, int max) async {
    final length = await file.length();
    final raf = await file.open();
    try {
      return await raf.read(min(length, max));
    } finally {
      await raf.close();
    }
  }
}

/// Runs on a background isolate: unzips an Office file and pulls text out of the
/// relevant XML parts (`<w:t>`, `<a:t>`, `<t>`).
String _officeText(List<int> bytes, String kind) {
  final archive = ZipDecoder().decodeBytes(bytes);
  final buffer = StringBuffer();
  for (final entry in archive) {
    if (!entry.isFile) continue;
    final name = entry.name;
    final include = switch (kind) {
      'docx' => name == 'word/document.xml' ||
          name.startsWith('word/header') ||
          name.startsWith('word/footer'),
      'xlsx' => name == 'xl/sharedStrings.xml',
      'pptx' =>
        name.startsWith('ppt/slides/slide') && name.endsWith('.xml'),
      _ => false,
    };
    if (!include) continue;
    final xml = utf8.decode(entry.content, allowMalformed: true);
    buffer
      ..write(_textFromOfficeXml(xml))
      ..write(' ');
  }
  return buffer.toString();
}

final _officeTextTag =
    RegExp(r'<(?:w:t|a:t|t)[^>]*>([^<]*)</(?:w:t|a:t|t)>', dotAll: true);

String _textFromOfficeXml(String xml) {
  final parts = _officeTextTag
      .allMatches(xml)
      .map((m) => _unescapeXml(m.group(1) ?? ''))
      .where((s) => s.isNotEmpty);
  return parts.join(' ');
}

String _unescapeXml(String s) => s
    .replaceAll('&amp;', '&')
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'");

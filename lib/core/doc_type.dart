/// Normalized document buckets used for filtering and iconography. The raw
/// extension is also stored on the document; this is the coarse category.
abstract final class DocType {
  static const pdf = 'pdf';
  static const image = 'image';
  static const office = 'office';
  static const archive = 'archive';
  static const text = 'text';
  static const other = 'other';

  static const _image = {
    'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic', 'heif', 'tif', 'tiff', 'svg',
  };
  static const _office = {
    'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'odt', 'ods', 'odp', 'rtf',
    'pages', 'numbers', 'key',
  };
  static const _archive = {'zip', '7z', 'rar', 'tar', 'gz', 'bz2', 'xz'};
  static const _text = {'txt', 'md', 'markdown', 'csv', 'tsv', 'json', 'xml', 'log', 'html', 'htm'};

  /// Classifies by extension (with or without a leading dot, any case).
  static String fromExtension(String? ext) {
    final e = (ext ?? '').toLowerCase().replaceFirst('.', '').trim();
    if (e.isEmpty) return other;
    if (e == 'pdf') return pdf;
    if (_image.contains(e)) return image;
    if (_office.contains(e)) return office;
    if (_archive.contains(e)) return archive;
    if (_text.contains(e)) return text;
    return other;
  }
}

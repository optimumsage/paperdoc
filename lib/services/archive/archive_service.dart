import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

/// Archive handling. v0.1 extracts ZIP (and the other formats the pure-Dart
/// `archive` package decodes). 7z and RAR need a native library (libarchive)
/// and are a follow-up; [canExtract] reports what's supported.
class ArchiveService {
  static const _extractable = {'zip'};

  bool canExtract(String? ext) =>
      ext != null && _extractable.contains(ext.toLowerCase());

  /// Extracts a ZIP archive into [destDir]; returns the extracted file paths.
  /// Entries that try to escape the destination (path traversal) are skipped.
  Future<List<String>> extractZip(String archivePath, String destDir) async {
    final bytes = await File(archivePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final dest = Directory(destDir);
    await dest.create(recursive: true);
    final destPath = p.normalize(dest.absolute.path);

    final extracted = <String>[];
    for (final file in archive) {
      if (!file.isFile) continue;
      final outPath = p.normalize(p.join(destPath, file.name));
      if (!p.isWithin(destPath, outPath)) continue; // reject traversal
      final out = File(outPath);
      await out.parent.create(recursive: true);
      await out.writeAsBytes(file.content);
      extracted.add(outPath);
    }
    return extracted;
  }
}

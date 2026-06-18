import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/services/archive/archive_service.dart';
import 'package:path/path.dart' as p;

void main() {
  test('extracts zip contents, including nested paths', () async {
    final tmp = await Directory.systemTemp.createTemp('paperdoc_zip_');
    addTearDown(() => tmp.delete(recursive: true));

    final archive = Archive()
      ..addFile(ArchiveFile.typedData(
          'a.txt', Uint8List.fromList(utf8.encode('hello'))))
      ..addFile(ArchiveFile.typedData(
          'sub/b.txt', Uint8List.fromList(utf8.encode('world'))));
    final zipBytes = ZipEncoder().encodeBytes(archive);
    final zipPath = p.join(tmp.path, 'test.zip');
    await File(zipPath).writeAsBytes(zipBytes);

    final dest = p.join(tmp.path, 'out');
    final extracted = await ArchiveService().extractZip(zipPath, dest);

    expect(extracted.length, 2);
    expect(await File(p.join(dest, 'a.txt')).readAsString(), 'hello');
    expect(await File(p.join(dest, 'sub', 'b.txt')).readAsString(), 'world');
  });

  test('canExtract reports supported formats', () {
    final svc = ArchiveService();
    expect(svc.canExtract('zip'), isTrue);
    expect(svc.canExtract('ZIP'), isTrue);
    expect(svc.canExtract('7z'), isFalse);
    expect(svc.canExtract('rar'), isFalse);
  });
}

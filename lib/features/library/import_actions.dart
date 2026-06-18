import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/providers.dart';

/// Opens the OS file picker and imports the chosen files into [folderUid].
/// Returns the number of documents imported.
Future<int> pickAndImport(WidgetRef ref, {String? folderUid}) async {
  final files = await openFiles();
  if (files.isEmpty) return 0;
  final paths = [for (final f in files) f.path];
  return importPaths(ref, paths, folderUid: folderUid);
}

/// Imports a concrete list of file paths (used by drag & drop too).
Future<int> importPaths(
  WidgetRef ref,
  List<String> paths, {
  String? folderUid,
}) async {
  final repo = ref.read(documentRepositoryProvider);
  var count = 0;
  for (final path in paths) {
    await repo.importFile(path, folderUid: folderUid);
    count++;
  }
  // Kick OCR for any freshly imported images in the background.
  if (count > 0) {
    unawaited(ref.read(ocrServiceProvider).processPending());
  }
  return count;
}

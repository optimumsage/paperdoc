import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../data/db/app_database.dart';
import 'document_actions.dart';

/// Whether the user wants separate files in a folder, or a single zip.
enum _ExportMode { individual, zip }

/// The on-disk name to export a document under — its original filename, falling
/// back to the (possibly edited) title plus extension.
String exportFileName(Document doc) {
  if (doc.originalName.trim().isNotEmpty) return doc.originalName;
  final ext = doc.ext;
  return ext != null && ext.isNotEmpty ? '${doc.title}.$ext' : doc.title;
}

/// "Downloads" (copies) a single document to a location the user picks, keeping
/// its original filename. Decrypts and downloads-on-demand as needed.
Future<void> exportDocument(
    BuildContext context, WidgetRef ref, Document doc) async {
  final messenger = ScaffoldMessenger.of(context);
  final name = exportFileName(doc);
  final location = await getSaveLocation(suggestedName: name);
  if (location == null) return;
  final bytes = await readDocumentBytes(ref, doc);
  if (bytes == null) {
    messenger.showSnackBar(
        SnackBar(content: Text('Could not read "${doc.title}".')));
    return;
  }
  await File(location.path).writeAsBytes(bytes);
  messenger.showSnackBar(SnackBar(content: Text('Saved "$name"')));
}

/// "Downloads" (copies) one or more documents to a location the user picks. For
/// a single document this is [exportDocument]; for several it asks whether to
/// copy them individually into a folder or bundle them into one zip.
Future<void> exportDocuments(
    BuildContext context, WidgetRef ref, List<Document> docs) async {
  if (docs.isEmpty) return;
  if (docs.length == 1) return exportDocument(context, ref, docs.first);

  final messenger = ScaffoldMessenger.of(context);
  final mode = await showDialog<_ExportMode>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Download ${docs.length} files'),
      content: const Text('How would you like to save them?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(_ExportMode.individual),
          child: const Text('Individual files'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_ExportMode.zip),
          child: const Text('Single ZIP'),
        ),
      ],
    ),
  );
  if (mode == null) return;

  if (mode == _ExportMode.individual) {
    await _exportIndividually(ref, docs, messenger);
  } else {
    await _exportZip(ref, docs, messenger);
  }
}

Future<void> _exportIndividually(
  WidgetRef ref,
  List<Document> docs,
  ScaffoldMessengerState messenger,
) async {
  final dir = await getDirectoryPath();
  if (dir == null) return;
  var saved = 0;
  var failed = 0;
  for (final doc in docs) {
    final bytes = await readDocumentBytes(ref, doc);
    if (bytes == null) {
      failed++;
      continue;
    }
    final target = await _nonClobberingFile(dir, exportFileName(doc));
    await target.writeAsBytes(bytes);
    saved++;
  }
  messenger.showSnackBar(SnackBar(
    content: Text(failed == 0
        ? 'Saved $saved file(s)'
        : 'Saved $saved file(s) · $failed failed'),
  ));
}

Future<void> _exportZip(
  WidgetRef ref,
  List<Document> docs,
  ScaffoldMessengerState messenger,
) async {
  final location = await getSaveLocation(suggestedName: 'documents.zip');
  if (location == null) return;
  final archive = Archive();
  final used = <String>{};
  var failed = 0;
  for (final doc in docs) {
    final bytes = await readDocumentBytes(ref, doc);
    if (bytes == null) {
      failed++;
      continue;
    }
    final name = _uniqueName(exportFileName(doc), used);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  }
  final encoded = ZipEncoder().encode(archive);
  await File(location.path).writeAsBytes(encoded);
  final count = archive.length;
  messenger.showSnackBar(SnackBar(
    content: Text(failed == 0
        ? 'Saved $count file(s) to ${p.basename(location.path)}'
        : 'Saved $count file(s) · $failed failed'),
  ));
}

/// Picks a file in [dir] named [name], appending " (n)" before the extension
/// if a file with that name already exists, so exports never overwrite.
Future<File> _nonClobberingFile(String dir, String name) async {
  final base = p.basenameWithoutExtension(name);
  final ext = p.extension(name);
  var candidate = File(p.join(dir, name));
  var i = 1;
  while (await candidate.exists()) {
    candidate = File(p.join(dir, '$base ($i)$ext'));
    i++;
  }
  return candidate;
}

/// Like [_nonClobberingFile] but for in-archive names tracked in [used].
String _uniqueName(String name, Set<String> used) {
  if (used.add(name)) return name;
  final base = p.basenameWithoutExtension(name);
  final ext = p.extension(name);
  var i = 1;
  while (!used.add('$base ($i)$ext')) {
    i++;
  }
  return '$base ($i)$ext';
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/file_reveal.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/providers.dart';
import 'widgets/library_dialogs.dart';

/// Opens a document with the OS default application. Encrypted documents are
/// decrypted to a temporary plaintext file first (required to hand off to an
/// external app).
Future<void> openDocument(WidgetRef ref, Document doc) async {
  final library = ref.read(libraryServiceProvider);
  if (doc.isEncrypted) {
    final encryption = ref.read(libraryEncryptionProvider);
    final cipher = await library.blobFile(doc.relPath).readAsBytes();
    final plaintext = await encryption.decrypt(cipher);
    final dir = await getTemporaryDirectory();
    final name = doc.ext != null ? '${doc.title}.${doc.ext}' : doc.title;
    final tmp = File(p.join(dir.path, 'paperdoc_open', name));
    await tmp.parent.create(recursive: true);
    await tmp.writeAsBytes(plaintext);
    await OpenFilex.open(tmp.path);
  } else {
    await OpenFilex.open(await library.blobAbsolutePath(doc.relPath));
  }
}

/// Reveals the document's stored file in the OS file manager (desktop).
Future<void> revealDocument(WidgetRef ref, Document doc) async {
  final path =
      await ref.read(libraryServiceProvider).blobAbsolutePath(doc.relPath);
  await revealInFileManager(path);
}

Future<void> renameDocument(
    BuildContext context, WidgetRef ref, Document doc) async {
  final name = await showTextPromptDialog(
    context,
    title: 'Rename document',
    label: 'Name',
    initialValue: doc.title,
  );
  if (name != null && name.isNotEmpty) {
    await ref.read(documentRepositoryProvider).rename(doc.uid, name);
  }
}

Future<void> moveDocument(
    BuildContext context, WidgetRef ref, Document doc) async {
  final folders = await ref.read(folderRepositoryProvider).watchAll().first;
  if (!context.mounted) return;
  final result = await showMoveToFolderDialog(
    context,
    folders: folders,
    currentFolderUid: doc.folderUid,
  );
  if (result != null) {
    await ref
        .read(documentRepositoryProvider)
        .moveToFolder(doc.uid, result.folderUid);
  }
}

Future<void> duplicateDocument(WidgetRef ref, Document doc) =>
    ref.read(documentRepositoryProvider).copyDocument(doc.uid);

Future<void> toggleStar(WidgetRef ref, Document doc) =>
    ref.read(documentRepositoryProvider).setStarred(doc.uid, !doc.starred);

/// Extracts a (zip) archive document into a new folder named after it.
Future<void> extractArchive(
    BuildContext context, WidgetRef ref, Document doc) async {
  final messenger = ScaffoldMessenger.of(context);
  final archive = ref.read(archiveServiceProvider);
  if (!archive.canExtract(doc.ext)) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Only ZIP archives can be extracted yet.')),
    );
    return;
  }

  final library = ref.read(libraryServiceProvider);
  final tmpRoot = await getTemporaryDirectory();
  final work = Directory(p.join(tmpRoot.path, 'paperdoc_extract', doc.uid));
  await work.create(recursive: true);
  try {
    final archivePath = p.join(work.path, 'archive.zip');
    if (doc.isEncrypted) {
      final cipher = await library.blobFile(doc.relPath).readAsBytes();
      final plain = await ref.read(libraryEncryptionProvider).decrypt(cipher);
      await File(archivePath).writeAsBytes(plain);
    } else {
      await File(await library.blobAbsolutePath(doc.relPath)).copy(archivePath);
    }

    final files = await archive.extractZip(archivePath, p.join(work.path, 'out'));
    final folder =
        await ref.read(folderRepositoryProvider).create(name: doc.title);
    final repo = ref.read(documentRepositoryProvider);
    for (final f in files) {
      await repo.importFile(f, folderUid: folder.uid);
    }
    messenger.showSnackBar(
      SnackBar(
          content:
              Text('Extracted ${files.length} file(s) into "${doc.title}"')),
    );
  } finally {
    if (work.existsSync()) await work.delete(recursive: true);
  }
}

/// Soft-deletes a document and offers Undo via a snackbar.
Future<void> deleteDocument(
    BuildContext context, WidgetRef ref, Document doc) async {
  final messenger = ScaffoldMessenger.of(context);
  await ref.read(documentRepositoryProvider).softDelete(doc.uid);
  messenger.showSnackBar(
    SnackBar(
      content: Text('"${doc.title}" moved to Trash'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () =>
            ref.read(documentRepositoryProvider).restore(doc.uid),
      ),
    ),
  );
}

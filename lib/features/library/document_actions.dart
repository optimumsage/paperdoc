import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/file_reveal.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/providers.dart';
import '../sync/sync_controller.dart';
import 'widgets/library_dialogs.dart';

/// Ensures a (possibly cloud-only) document's blob is on disk, fetching it on
/// demand. Returns the up-to-date document, or null if a needed download
/// failed (the caller should abort the blob-reading action).
Future<Document?> _ensureLocal(WidgetRef ref, Document doc) async {
  if (doc.downloadState == 'local') return doc;
  final ok = await ref.read(syncControllerProvider.notifier).ensureLocal(doc);
  if (!ok) return null;
  return ref.read(documentRepositoryProvider).findByUid(doc.uid);
}

/// Returns a document's plaintext bytes — downloading a cloud-only blob on
/// demand and decrypting an encrypted one. Null if a needed download failed.
Future<List<int>?> readDocumentBytes(WidgetRef ref, Document doc) async {
  final ready = await _ensureLocal(ref, doc);
  if (ready == null) return null;
  doc = ready;
  final library = ref.read(libraryServiceProvider);
  if (doc.isEncrypted) {
    final cipher = await library.blobFile(doc.relPath).readAsBytes();
    return ref.read(libraryEncryptionProvider).decrypt(cipher);
  }
  return library.blobFile(doc.relPath).readAsBytes();
}

/// Pins a cloud-only document for offline use (downloads it now), with feedback.
Future<void> keepOffline(
    BuildContext context, WidgetRef ref, Document doc) async {
  final messenger = ScaffoldMessenger.of(context);
  messenger.showSnackBar(
      SnackBar(content: Text('Downloading "${doc.title}"…')));
  final ready = await _ensureLocal(ref, doc);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(
    content: Text(ready != null
        ? '"${doc.title}" is now available offline'
        : 'Could not download "${doc.title}"'),
  ));
}

/// Reverts a locally-cached document to cloud-only, freeing its disk space.
Future<void> freeUpSpace(
    BuildContext context, WidgetRef ref, Document doc) async {
  final messenger = ScaffoldMessenger.of(context);
  final ok = await ref.read(documentRepositoryProvider).freeUpSpace(doc.uid);
  messenger.showSnackBar(SnackBar(
    content: Text(ok
        ? '"${doc.title}" moved to the cloud — opens will re-download it'
        : "\"${doc.title}\" isn't backed up to the cloud yet"),
  ));
}

/// Opens a document with the OS default application. Encrypted documents are
/// decrypted to a temporary plaintext file first (required to hand off to an
/// external app). Cloud-only documents are downloaded on demand first.
Future<void> openDocument(WidgetRef ref, Document doc) async {
  final ready = await _ensureLocal(ref, doc);
  if (ready == null) return;
  doc = ready;
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
  final ready = await _ensureLocal(ref, doc);
  if (ready == null) return;
  final path =
      await ref.read(libraryServiceProvider).blobAbsolutePath(ready.relPath);
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

Future<void> duplicateDocument(WidgetRef ref, Document doc) async {
  final ready = await _ensureLocal(ref, doc);
  if (ready == null) return;
  await ref.read(documentRepositoryProvider).copyDocument(ready.uid);
}

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

  final ready = await _ensureLocal(ref, doc);
  if (ready == null) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Could not download the archive.')),
    );
    return;
  }
  doc = ready;

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

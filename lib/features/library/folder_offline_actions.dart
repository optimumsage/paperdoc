import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/providers.dart';
import '../sync/sync_controller.dart';

/// Collects every non-deleted document inside [folderUid] and its sub-folders.
Future<List<Document>> _docsUnder(WidgetRef ref, String folderUid) async {
  final folderUids =
      await ref.read(folderRepositoryProvider).descendantUids(folderUid);
  return ref.read(documentRepositoryProvider).documentsInFolders(folderUids);
}

/// Downloads every cloud-only document in a folder (and its sub-folders) so the
/// whole folder is available offline.
Future<void> keepFolderOffline(
    BuildContext context, WidgetRef ref, String folderUid) async {
  final messenger = ScaffoldMessenger.of(context);
  final docs = await _docsUnder(ref, folderUid);
  final pending =
      docs.where((d) => d.downloadState != 'local').toList(growable: false);
  if (pending.isEmpty) {
    messenger.showSnackBar(const SnackBar(
        content: Text('Everything in this folder is already offline.')));
    return;
  }
  messenger.showSnackBar(
      SnackBar(content: Text('Downloading ${pending.length} file(s)…')));
  var ok = 0;
  var failed = 0;
  final sync = ref.read(syncControllerProvider.notifier);
  for (final doc in pending) {
    await sync.ensureLocal(doc) ? ok++ : failed++;
  }
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(
    content: Text(failed == 0
        ? '$ok file(s) now available offline'
        : '$ok downloaded · $failed failed'),
  ));
}

/// Reverts every locally-cached document in a folder (and its sub-folders) to
/// cloud-only, freeing disk space (only files that are backed up are touched).
Future<void> freeFolderSpace(
    BuildContext context, WidgetRef ref, String folderUid) async {
  final messenger = ScaffoldMessenger.of(context);
  final docs = await _docsUnder(ref, folderUid);
  final repo = ref.read(documentRepositoryProvider);
  var freed = 0;
  for (final doc in docs) {
    if (doc.downloadState == 'local' && await repo.freeUpSpace(doc.uid)) {
      freed++;
    }
  }
  messenger.showSnackBar(SnackBar(
    content: Text(freed == 0
        ? 'Nothing to free up in this folder.'
        : '$freed file(s) moved to the cloud'),
  ));
}

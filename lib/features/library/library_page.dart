import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/document_repository.dart';
import '../../data/repositories/providers.dart';
import '../security/library_lock_controller.dart';
import '../security/lock_screen.dart';
import '../sync/sync_controller.dart';
import '../watch/watch_inbox.dart';
import 'import_actions.dart';
import 'library_controller.dart';
import 'library_setup_view.dart';
import 'selection_controller.dart';
import 'widgets/document_area.dart';
import 'widgets/folder_sidebar.dart';
import 'widgets/library_dialogs.dart';

/// Library destination. Shows the first-run setup until a library root is
/// chosen, then the two-pane browser.
class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootAsync = ref.watch(currentLibraryRootProvider);
    return rootAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (root) {
        if (root == null) return const LibrarySetupView();
        final lock = ref.watch(libraryLockProvider);
        if (lock.locked) return const LockScreen();
        return const _LibraryBrowser();
      },
    );
  }
}

class _LibraryBrowser extends ConsumerWidget {
  const _LibraryBrowser();

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final folderUid =
        importFolderForSelection(ref.read(folderSelectionProvider));
    try {
      final n = await pickAndImport(ref, folderUid: folderUid);
      if (n > 0) {
        messenger.showSnackBar(SnackBar(content: Text('Imported $n file(s)')));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('Import failed: $e'),
        duration: const Duration(seconds: 8),
      ));
    }
  }

  Future<void> _scan(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final paths = await ref.read(docScannerProvider).scan();
    if (paths.isEmpty) return;
    final folderUid =
        importFolderForSelection(ref.read(folderSelectionProvider));
    final n = await importPaths(ref, paths, folderUid: folderUid);
    if (n > 0) {
      messenger.showSnackBar(SnackBar(content: Text('Scanned $n document(s)')));
    }
  }

  Future<void> _bulkDelete(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final uids = ref.read(selectionProvider).toList();
    final repo = ref.read(documentRepositoryProvider);
    await repo.bulkSoftDelete(uids);
    ref.read(selectionProvider.notifier).clear();
    messenger.showSnackBar(SnackBar(
      content: Text('${uids.length} moved to Trash'),
      action: SnackBarAction(
          label: 'Undo', onPressed: () => repo.bulkRestore(uids)),
    ));
  }

  Future<void> _bulkMove(BuildContext context, WidgetRef ref) async {
    final folders = await ref.read(folderRepositoryProvider).watchAll().first;
    if (!context.mounted) return;
    final result = await showMoveToFolderDialog(context, folders: folders);
    if (result != null) {
      final uids = ref.read(selectionProvider).toList();
      await ref
          .read(documentRepositoryProvider)
          .bulkMoveToFolder(uids, result.folderUid);
      ref.read(selectionProvider.notifier).clear();
    }
  }

  Future<void> _bulkStar(WidgetRef ref) async {
    final uids = ref.read(selectionProvider).toList();
    await ref.read(documentRepositoryProvider).bulkSetStarred(uids, true);
    ref.read(selectionProvider.notifier).clear();
  }

  PreferredSizeWidget _selectionAppBar(
      BuildContext context, WidgetRef ref, int count) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Clear selection',
        onPressed: () => ref.read(selectionProvider.notifier).clear(),
      ),
      title: Text('$count selected'),
      actions: [
        IconButton(
          tooltip: 'Star',
          icon: const Icon(Icons.star_border),
          onPressed: () => _bulkStar(ref),
        ),
        IconButton(
          tooltip: 'Move to folder',
          icon: const Icon(Icons.drive_file_move_outline),
          onPressed: () => _bulkMove(context, ref),
        ),
        IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _bulkDelete(context, ref),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final viewMode = ref.watch(documentViewModeProvider);
    final scanner = ref.watch(docScannerProvider);
    final selectionCount = ref.watch(selectionProvider).length;
    final syncState = ref.watch(syncControllerProvider);

    // Surface sync results/errors from anywhere the sync button is used, so the
    // feedback isn't trapped inside the Settings page.
    ref.listen(syncControllerProvider, (prev, next) {
      final messenger = ScaffoldMessenger.of(context);
      if (next.error != null && next.error != prev?.error) {
        messenger.showSnackBar(SnackBar(content: Text(next.error!)));
      } else if (!next.busy &&
          next.lastReport != null &&
          next.lastReport != prev?.lastReport) {
        messenger.showSnackBar(SnackBar(content: Text(next.lastReport!)));
      }
    });

    return Scaffold(
      floatingActionButton: scanner.isSupported && selectionCount == 0
          ? FloatingActionButton.extended(
              onPressed: () => _scan(context, ref),
              icon: const Icon(Icons.document_scanner_outlined),
              label: const Text('Scan'),
            )
          : null,
      appBar: selectionCount > 0
          ? _selectionAppBar(context, ref, selectionCount)
          : AppBar(
              automaticallyImplyLeading: false,
        leading: wide
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.folder_outlined),
                  tooltip: 'Folders',
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        title: const Text('Library'),
        actions: [
          IconButton(
            tooltip: syncState.busy
                ? 'Syncing…'
                : (syncState.connected ? 'Sync now' : 'Set up sync'),
            onPressed: syncState.busy
                ? null
                : () {
                    if (syncState.connected) {
                      ref.read(syncControllerProvider.notifier).syncNow();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Set up Google Drive sync in Settings.'),
                        ),
                      );
                    }
                  },
            icon: syncState.busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
          ),
          Builder(
            builder: (context) {
              final count = ref.watch(pendingSuggestionsProvider).asData?.value
                      .length ??
                  0;
              return IconButton(
                tooltip: 'Suggestions',
                onPressed: () => showWatchInbox(context),
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: const Icon(Icons.inbox_outlined),
                ),
              );
            },
          ),
          PopupMenuButton<DocumentSort>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            onSelected: (s) =>
                ref.read(documentSortProvider.notifier).set(s),
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: DocumentSort.recent, child: Text('Recently added')),
              PopupMenuItem(
                  value: DocumentSort.nameAsc, child: Text('Name (A–Z)')),
              PopupMenuItem(
                  value: DocumentSort.modified, child: Text('Date modified')),
              PopupMenuItem(
                  value: DocumentSort.sizeDesc, child: Text('Size (largest)')),
              PopupMenuItem(value: DocumentSort.typeAsc, child: Text('Type')),
            ],
          ),
          IconButton(
            tooltip: viewMode == DocumentViewMode.grid
                ? 'List view'
                : 'Grid view',
            icon: Icon(viewMode == DocumentViewMode.grid
                ? Icons.view_list_outlined
                : Icons.grid_view_outlined),
            onPressed: () =>
                ref.read(documentViewModeProvider.notifier).toggle(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FilledButton.icon(
              onPressed: () => _import(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Import'),
            ),
          ),
        ],
      ),
      drawer: wide
          ? null
          : const Drawer(child: SafeArea(child: FolderSidebar())),
      body: wide
          ? Row(
              children: const [
                SizedBox(width: 256, child: FolderSidebar()),
                VerticalDivider(width: 1),
                Expanded(child: DocumentArea()),
              ],
            )
          : const DocumentArea(),
    );
  }
}

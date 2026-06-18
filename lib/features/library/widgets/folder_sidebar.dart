import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/repositories/providers.dart';
import '../library_controller.dart';
import 'library_dialogs.dart';

/// Left-hand navigation of the library: special scopes (All / Unfiled) plus the
/// user's top-level folders. M1 keeps the folder list flat; nesting in the UI
/// comes later (the data model already supports it).
class FolderSidebar extends ConsumerWidget {
  const FolderSidebar({super.key});

  Future<void> _createFolder(BuildContext context, WidgetRef ref) async {
    final name = await showTextPromptDialog(
      context,
      title: 'New folder',
      label: 'Folder name',
      confirmText: 'Create',
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(folderRepositoryProvider).create(name: name);
    }
  }

  Future<void> _renameFolder(
      BuildContext context, WidgetRef ref, Folder folder) async {
    final name = await showTextPromptDialog(
      context,
      title: 'Rename folder',
      label: 'Folder name',
      initialValue: folder.name,
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(folderRepositoryProvider).rename(folder.uid, name);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(folderSelectionProvider);
    final foldersAsync = ref.watch(rootFoldersProvider);

    void select(FolderSelection s) =>
        ref.read(folderSelectionProvider.notifier).set(s);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _NavEntry(
          icon: Icons.all_inbox_outlined,
          label: 'All Documents',
          selected: selection.scope == BrowseScope.all,
          onTap: () => select(const FolderSelection.all()),
        ),
        _NavEntry(
          icon: Icons.inbox_outlined,
          label: 'Unfiled',
          selected: selection.scope == BrowseScope.unfiled,
          onTap: () => select(const FolderSelection.unfiled()),
        ),
        const Divider(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
          child: Row(
            children: [
              Expanded(
                child: Text('FOLDERS',
                    style: Theme.of(context).textTheme.labelSmall),
              ),
              IconButton(
                tooltip: 'New folder',
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => _createFolder(context, ref),
              ),
            ],
          ),
        ),
        Expanded(
          child: foldersAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (folders) {
              if (folders.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No folders yet.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.only(bottom: 8),
                children: [
                  for (final folder in folders)
                    _NavEntry(
                      icon: Icons.folder_outlined,
                      label: folder.name,
                      selected: selection.scope == BrowseScope.folder &&
                          selection.folderUid == folder.uid,
                      onTap: () => select(
                          FolderSelection(BrowseScope.folder, folder.uid)),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz, size: 18),
                        onSelected: (v) async {
                          if (v == 'rename') {
                            await _renameFolder(context, ref, folder);
                          } else if (v == 'delete') {
                            await ref
                                .read(folderRepositoryProvider)
                                .softDelete(folder.uid);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                              value: 'rename', child: Text('Rename')),
                          PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NavEntry extends StatelessWidget {
  const _NavEntry({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: selected ? scheme.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon,
                    size: 20,
                    color: selected
                        ? scheme.onSecondaryContainer
                        : scheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? scheme.onSecondaryContainer
                          : scheme.onSurface,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

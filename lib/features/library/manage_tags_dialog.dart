import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/providers.dart';
import 'widgets/library_dialogs.dart';

/// Shows the tag manager, where tags can be renamed or deleted library-wide.
Future<void> showManageTagsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _ManageTagsDialog(),
  );
}

class _ManageTagsDialog extends ConsumerWidget {
  const _ManageTagsDialog();

  Future<void> _rename(BuildContext context, WidgetRef ref, Tag tag) async {
    final name = await showTextPromptDialog(
      context,
      title: 'Rename tag',
      label: 'Tag name',
      initialValue: tag.name,
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(tagRepositoryProvider).rename(tag.uid, name);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Tag tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${tag.name}"?'),
        content: const Text(
            'The tag will be removed from every document. This cannot be '
            'undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(tagRepositoryProvider).softDelete(tag.uid);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(allTagsProvider).asData?.value ?? const <Tag>[];
    return AlertDialog(
      title: const Text('Manage tags'),
      content: SizedBox(
        width: 360,
        child: tags.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No tags yet.'),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  for (final tag in tags)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.label_outline),
                      title: Text(tag.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Rename',
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _rename(context, ref, tag),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(context, ref, tag),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

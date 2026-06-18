import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../data/repositories/providers.dart';

Future<void> showWatchInbox(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 560),
    builder: (_) => const _WatchInbox(),
  );
}

class _WatchInbox extends ConsumerWidget {
  const _WatchInbox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(pendingSuggestionsProvider);
    final repo = ref.read(watchSuggestionRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Suggested files',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              if ((suggestions.asData?.value.isNotEmpty) ?? false)
                TextButton(
                  onPressed: repo.dismissAll,
                  child: const Text('Dismiss all'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          suggestions.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (items) {
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No suggestions right now.')),
                );
              }
              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final s = items[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.insert_drive_file_outlined),
                      title: Text(p.basename(s.srcPath),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(s.srcPath,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => repo.dismiss(s.id),
                            child: const Text('Dismiss'),
                          ),
                          FilledButton(
                            onPressed: () => repo.accept(s),
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

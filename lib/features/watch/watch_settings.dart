import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/platform_info.dart';
import '../../data/repositories/providers.dart';

/// Settings section to manage watched directories and trigger a scan. Watch
/// folders are desktop-oriented (Android scoped storage limits arbitrary
/// directory scanning — a follow-up).
class WatchSettings extends ConsumerWidget {
  const WatchSettings({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final path = await getDirectoryPath(
      confirmButtonText: 'Watch',
    );
    if (path != null) {
      await ref.read(watchDirRepositoryProvider).add(path: path);
    }
  }

  Future<void> _scan(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final count = await ref.read(watchServiceProvider).scanAll();
    messenger.showSnackBar(
      SnackBar(content: Text('Found $count new file(s)')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dirs = ref.watch(watchDirsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.folder_special_outlined),
          title: const Text('Watch folders'),
          subtitle: const Text('Suggest new files (e.g. from Downloads)'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: () => _scan(context, ref),
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Scan'),
              ),
              IconButton(
                tooltip: 'Add folder',
                onPressed: () => _add(context, ref),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        dirs.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $e'),
          ),
          data: (list) {
            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  PlatformInfo.isAndroid
                      ? 'Watch folders work best on desktop.'
                      : 'No watched folders yet.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
            return Column(
              children: [
                for (final dir in list)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(dir.path,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: dir.enabled,
                          onChanged: (v) => ref
                              .read(watchDirRepositoryProvider)
                              .setEnabled(dir.id, v),
                        ),
                        IconButton(
                          tooltip: 'Remove',
                          icon: const Icon(Icons.close),
                          onPressed: () => ref
                              .read(watchDirRepositoryProvider)
                              .remove(dir.id),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

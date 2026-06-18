import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/platform_info.dart';
import '../../data/repositories/providers.dart';
import 'library_controller.dart';

/// First-run screen: the user picks a folder to hold their managed library.
class LibrarySetupView extends ConsumerStatefulWidget {
  const LibrarySetupView({super.key});

  @override
  ConsumerState<LibrarySetupView> createState() => _LibrarySetupViewState();
}

class _LibrarySetupViewState extends ConsumerState<LibrarySetupView> {
  bool _busy = false;

  Future<void> _useDefault() async {
    setState(() => _busy = true);
    try {
      final path = await ref.read(libraryServiceProvider).defaultRootPath();
      await ref.read(currentLibraryRootProvider.notifier).choose(path);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _chooseCustom() async {
    setState(() => _busy = true);
    try {
      final path = await getDirectoryPath(
        confirmButtonText: 'Choose',
      );
      if (path != null) {
        await ref.read(currentLibraryRootProvider.notifier).choose(path);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.description,
                      size: 38, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(height: 24),
                Text('Welcome to PaperDoc',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(
                  'Choose a folder to store your library. Documents you import '
                  'are organized and kept here — this is also what syncs to the '
                  'cloud later.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _busy ? null : _useDefault,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: const Text('Use default location'),
                ),
                if (PlatformInfo.isDesktop) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _chooseCustom,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Choose a custom folder…'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

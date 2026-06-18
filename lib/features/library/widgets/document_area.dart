import 'dart:async';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/providers.dart';
import '../import_actions.dart';
import '../library_controller.dart';
import 'document_tile.dart';

/// The main document area: a grid or list of documents for the current
/// selection, with drag-and-drop import.
class DocumentArea extends ConsumerStatefulWidget {
  const DocumentArea({super.key});

  @override
  ConsumerState<DocumentArea> createState() => _DocumentAreaState();
}

class _DocumentAreaState extends ConsumerState<DocumentArea> {
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    // Process pending OCR, back-fill text extraction for older imports, and
    // scan watch folders when the library opens.
    unawaited(Future.microtask(() async {
      await ref.read(ocrServiceProvider).processPending();
      await ref.read(documentRepositoryProvider).reextractMissing();
      await ref.read(watchServiceProvider).scanAll();
    }));
  }

  String? get _importFolder =>
      importFolderForSelection(ref.read(folderSelectionProvider));

  Future<void> _importPicked() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final n = await pickAndImport(ref, folderUid: _importFolder);
      if (n > 0) {
        messenger.showSnackBar(SnackBar(content: Text('Imported $n file(s)')));
      }
    } catch (e) {
      _showImportError(messenger, e);
    }
  }

  Future<void> _onDrop(DropDoneDetails detail) async {
    setState(() => _dragging = false);
    final messenger = ScaffoldMessenger.of(context);
    final paths = [for (final f in detail.files) f.path];
    if (paths.isEmpty) return;
    try {
      final n = await importPaths(ref, paths, folderUid: _importFolder);
      if (n > 0) {
        messenger.showSnackBar(SnackBar(content: Text('Imported $n file(s)')));
      }
    } catch (e) {
      _showImportError(messenger, e);
    }
  }

  void _showImportError(ScaffoldMessengerState messenger, Object error) {
    messenger.showSnackBar(SnackBar(
      content: Text('Import failed: $error'),
      duration: const Duration(seconds: 8),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final docsAsync = ref.watch(visibleDocumentsProvider);
    final viewMode = ref.watch(documentViewModeProvider);
    final scheme = Theme.of(context).colorScheme;

    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: _onDrop,
      child: Stack(
        children: [
          docsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (docs) {
              if (docs.isEmpty) {
                return _EmptyState(onImport: _importPicked);
              }
              if (viewMode == DocumentViewMode.list) {
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) =>
                      DocumentTile(doc: docs[i], grid: false),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.82,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: docs.length,
                itemBuilder: (context, i) => DocumentTile(doc: docs[i]),
              );
            },
          ),
          if (_dragging)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: scheme.primary.withValues(alpha: 0.08),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: scheme.primary, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.file_download_outlined,
                              size: 40, color: scheme.primary),
                          const SizedBox(height: 8),
                          const Text('Drop to import'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onImport});
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open_outlined, size: 64, color: scheme.outline),
          const SizedBox(height: 16),
          Text('No documents here',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Import files or drag & drop them here.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onImport,
            icon: const Icon(Icons.add),
            label: const Text('Import files'),
          ),
        ],
      ),
    );
  }
}

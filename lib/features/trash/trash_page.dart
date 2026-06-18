import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/document_repository.dart';
import '../../data/repositories/providers.dart';
import '../library/doc_visuals.dart';
import '../library/widgets/library_dialogs.dart';

/// Trash destination: lists soft-deleted documents with restore and permanent
/// delete, plus "empty trash". Permanent delete removes the blob from disk
/// (and, once sync lands, from the cloud).
class TrashPage extends ConsumerWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashAsync = ref.watch(trashProvider);
    final repo = ref.read(documentRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          trashAsync.maybeWhen(
            data: (docs) => docs.isEmpty
                ? const SizedBox.shrink()
                : TextButton.icon(
                    onPressed: () async {
                      final ok = await showConfirmDialog(
                        context,
                        title: 'Empty Trash',
                        message:
                            'Permanently delete all ${docs.length} item(s)? '
                            'This cannot be undone.',
                        confirmText: 'Empty Trash',
                      );
                      if (ok) await repo.emptyTrash();
                    },
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: const Text('Empty Trash'),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: trashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (docs) {
          if (docs.isEmpty) {
            return _EmptyTrash();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, i) =>
                _TrashRow(doc: docs[i], repo: repo),
          );
        },
      ),
    );
  }
}

class _TrashRow extends StatelessWidget {
  const _TrashRow({required this.doc, required this.repo});

  final Document doc;
  final DocumentRepository repo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = docTypeColor(doc.docType, scheme);
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: accent.withValues(alpha: 0.15),
          child: Icon(docTypeIcon(doc.docType), color: accent),
        ),
        title: Text(doc.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(formatBytes(doc.sizeBytes)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => repo.restore(doc.uid),
              child: const Text('Restore'),
            ),
            IconButton(
              tooltip: 'Delete forever',
              icon: const Icon(Icons.delete_forever_outlined),
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: 'Delete forever',
                  message: 'Permanently delete "${doc.title}"? '
                      'This cannot be undone.',
                  confirmText: 'Delete forever',
                );
                if (ok) await repo.permanentDelete(doc.uid);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTrash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline, size: 64, color: scheme.outline),
          const SizedBox(height: 16),
          Text('Trash is empty',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Deleted documents appear here before permanent removal.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

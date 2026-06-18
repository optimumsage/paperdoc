import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/document_repository.dart';
import '../../data/repositories/providers.dart';
import '../library/doc_visuals.dart';

/// Lists groups of exact-duplicate documents (identical content) and lets the
/// user clean them up — keep one, delete the rest, or delete individually.
class DuplicatesPage extends ConsumerWidget {
  const DuplicatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(duplicateGroupsProvider);
    final repo = ref.read(documentRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Duplicate files')),
      body: groups.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const _Empty();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) => _GroupCard(group: list[i], repo: repo),
          );
        },
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.repo});

  final List<Document> group;
  final DocumentRepository repo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${group.length} identical copies · ${formatBytes(group.first.sizeBytes)}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      for (final d in group.skip(1)) {
                        repo.softDelete(d.uid);
                      }
                    },
                    child: const Text('Keep one'),
                  ),
                ],
              ),
            ),
            for (final doc in group)
              ListTile(
                dense: true,
                leading: Icon(docTypeIcon(doc.docType),
                    color: docTypeColor(doc.docType, scheme)),
                title:
                    Text(doc.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(doc.folderUid == null ? 'Unfiled' : 'In a folder'),
                trailing: IconButton(
                  tooltip: 'Move to Trash',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => repo.softDelete(doc.uid),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.done_all, size: 64, color: scheme.outline),
          const SizedBox(height: 16),
          Text('No duplicate files',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

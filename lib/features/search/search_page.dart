import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/doc_type.dart';
import '../../data/models/search_query.dart';
import '../../data/repositories/providers.dart';
import '../library/widgets/document_tile.dart';
import '../library/widgets/library_dialogs.dart';
import 'search_controller.dart';

const _typeChoices = <(String, String)>[
  ('PDF', DocType.pdf),
  ('Images', DocType.image),
  ('Office', DocType.office),
  ('Text', DocType.text),
  ('Archives', DocType.archive),
];

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange(SearchQuery query) async {
    final now = DateTime.now();
    final initial = query.createdFromMs != null && query.createdToMs != null
        ? DateTimeRange(
            start: DateTime.fromMillisecondsSinceEpoch(query.createdFromMs!),
            end: DateTime.fromMillisecondsSinceEpoch(query.createdToMs!),
          )
        : null;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initial,
    );
    if (picked != null) {
      final from = DateTime(picked.start.year, picked.start.month,
              picked.start.day)
          .millisecondsSinceEpoch;
      final to = DateTime(picked.end.year, picked.end.month, picked.end.day)
              .add(const Duration(days: 1))
              .millisecondsSinceEpoch -
          1;
      ref.read(searchQueryProvider.notifier).setDateRange(from, to);
    }
  }

  Future<void> _saveSmartFolder(SearchQuery query) async {
    final name = await showTextPromptDialog(
      context,
      title: 'Save smart folder',
      label: 'Name',
      confirmText: 'Save',
    );
    if (name != null && name.isNotEmpty) {
      await ref
          .read(smartFolderRepositoryProvider)
          .create(name: name, query: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final allTags = ref.watch(allTagsProvider).asData?.value ?? [];
    final smartFolders = ref.watch(smartFoldersProvider).asData?.value ?? [];
    final notifier = ref.read(searchQueryProvider.notifier);

    // Keep the text field in sync when the query is changed elsewhere
    // (loading a smart folder, Clear).
    ref.listen(searchQueryProvider, (_, next) {
      if (next.text != _controller.text) _controller.text = next.text;
    });

    final hasDate = query.createdFromMs != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          if (!query.isEmpty)
            TextButton(
              onPressed: notifier.clear,
              child: const Text('Clear'),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: notifier.setText,
              decoration: InputDecoration(
                hintText: 'Search names, content, tags…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => notifier.setText(''),
                      ),
              ),
            ),
          ),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final (label, type) in _typeChoices) ...[
                  FilterChip(
                    label: Text(label),
                    selected: query.docTypes.contains(type),
                    onSelected: (_) => notifier.toggleType(type),
                  ),
                  const SizedBox(width: 8),
                ],
                FilterChip(
                  avatar: const Icon(Icons.calendar_today, size: 16),
                  label: Text(hasDate ? _dateLabel(query) : 'Any date'),
                  selected: hasDate,
                  onSelected: (_) {
                    if (hasDate) {
                      notifier.setDateRange(null, null);
                    } else {
                      _pickDateRange(query);
                    }
                  },
                ),
              ],
            ),
          ),

          if (allTags.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  for (final tag in allTags) ...[
                    FilterChip(
                      avatar: const Icon(Icons.label_outline, size: 16),
                      label: Text(tag.name),
                      selected: query.tagUids.contains(tag.uid),
                      onSelected: (_) => notifier.toggleTag(tag.uid),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),

          // Smart folders
          if (smartFolders.isNotEmpty || !query.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final sf in smartFolders) ...[
                            ActionChip(
                              avatar: const Icon(Icons.bookmark_border,
                                  size: 16),
                              label: Text(sf.name),
                              onPressed: () => notifier.load(
                                  ref
                                      .read(smartFolderRepositoryProvider)
                                      .queryOf(sf)),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (!query.isEmpty)
                    TextButton.icon(
                      onPressed: () => _saveSmartFolder(query),
                      icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                      label: const Text('Save'),
                    ),
                ],
              ),
            ),

          const Divider(height: 16),

          Expanded(
            child: query.isEmpty
                ? const _Prompt()
                : results.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (docs) => docs.isEmpty
                        ? const _NoResults()
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: docs.length,
                            itemBuilder: (context, i) =>
                                DocumentTile(doc: docs[i], grid: false),
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  String _dateLabel(SearchQuery query) {
    final from = DateTime.fromMillisecondsSinceEpoch(query.createdFromMs!);
    final to = DateTime.fromMillisecondsSinceEpoch(query.createdToMs!);
    final fmt = DateFormat.MMMd();
    return '${fmt.format(from)} – ${fmt.format(to)}';
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 64, color: scheme.outline),
          const SizedBox(height: 16),
          Text('Search your documents',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'By name, content, tags, type, or date.',
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

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: scheme.outline),
          const SizedBox(height: 16),
          Text('No matching documents',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

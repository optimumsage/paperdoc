import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/doc_type.dart';
import '../../core/format.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/providers.dart';
import '../../services/ocr/ocr_service.dart';
import '../library/doc_visuals.dart';
import '../library/document_actions.dart';
import '../library/widgets/library_dialogs.dart';

/// Opens the document detail panel as a bottom sheet (centered + constrained on
/// desktop). This is where a document's tags, labels, category, and metadata
/// are viewed and edited.
Future<void> showDocumentDetail(BuildContext context, String docUid) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 560),
    builder: (_) => DocumentDetailSheet(docUid: docUid),
  );
}

class DocumentDetailSheet extends ConsumerWidget {
  const DocumentDetailSheet({required this.docUid, super.key});

  final String docUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docAsync = ref.watch(documentByUidProvider(docUid));
    return docAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SizedBox(height: 120, child: Center(child: Text('$e'))),
      data: (doc) =>
          doc == null ? const SizedBox.shrink() : _Content(doc: doc),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.doc});

  final Document doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final accent = docTypeColor(doc.docType, scheme);
    final imported =
        DateTime.fromMillisecondsSinceEpoch(doc.importedAt);

    final tags = ref.watch(tagsForDocumentProvider(doc.uid)).asData?.value ?? [];
    final allTags = ref.watch(allTagsProvider).asData?.value ?? [];
    final labels =
        ref.watch(labelsForDocumentProvider(doc.uid)).asData?.value ?? [];
    final allLabels = ref.watch(allLabelsProvider).asData?.value ?? [];
    final categories = ref.watch(allCategoriesProvider).asData?.value ?? [];

    final tagRepo = ref.read(tagRepositoryProvider);
    final labelRepo = ref.read(labelRepositoryProvider);
    final docRepo = ref.read(documentRepositoryProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accent.withValues(alpha: 0.15),
                  child: Icon(docTypeIcon(doc.docType), color: accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    doc.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: doc.starred ? 'Unstar' : 'Star',
                  icon: Icon(doc.starred ? Icons.star : Icons.star_border,
                      color: doc.starred ? const Color(0xFFE0A100) : null),
                  onPressed: () => toggleStar(ref, doc),
                ),
                IconButton(
                  tooltip: 'Rename',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => renameDocument(context, ref, doc),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Metadata
            _MetaRow(label: 'Type', value: (doc.ext ?? '—').toUpperCase()),
            _MetaRow(label: 'Size', value: formatBytes(doc.sizeBytes)),
            _MetaRow(label: 'Original name', value: doc.originalName),
            _MetaRow(
                label: 'Imported', value: DateFormat.yMMMd().format(imported)),
            if (doc.docType == DocType.image)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text('OCR',
                          style: TextStyle(color: scheme.onSurfaceVariant)),
                    ),
                    Expanded(child: Text(_ocrLabel(doc.ocrStatus))),
                    TextButton(
                      onPressed: () =>
                          ref.read(ocrServiceProvider).requestOcr(doc.uid),
                      child: Text(
                          doc.ocrStatus == OcrStatus.done ? 'Re-run' : 'Run'),
                    ),
                  ],
                ),
              ),

            const Divider(height: 28),

            // Category (single-select)
            _SectionLabel('Category'),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('None'),
                  selected: doc.categoryUid == null,
                  onSelected: (_) => docRepo.setCategory(doc.uid, null),
                ),
                for (final c in categories)
                  ChoiceChip(
                    label: Text(c.name),
                    selected: doc.categoryUid == c.uid,
                    onSelected: (_) => docRepo.setCategory(doc.uid, c.uid),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('New'),
                  onPressed: () async {
                    final name = await showTextPromptDialog(
                      context,
                      title: 'New category',
                      label: 'Category name',
                      confirmText: 'Create',
                    );
                    if (name != null && name.isNotEmpty) {
                      final cat = await ref
                          .read(categoryRepositoryProvider)
                          .create(name: name);
                      await docRepo.setCategory(doc.uid, cat.uid);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tags (multi-select)
            _ChipPicker(
              title: 'Tags',
              selected: {for (final t in tags) t.uid: t.name},
              available: {for (final t in allTags) t.uid: t.name},
              onAdd: (uid) => tagRepo.assign(doc.uid, uid),
              onRemove: (uid) => tagRepo.unassign(doc.uid, uid),
              onCreate: (name) async {
                final t = await tagRepo.create(name: name);
                await tagRepo.assign(doc.uid, t.uid);
              },
            ),

            const SizedBox(height: 20),

            // Labels (multi-select)
            _ChipPicker(
              title: 'Labels',
              selected: {for (final l in labels) l.uid: l.name},
              available: {for (final l in allLabels) l.uid: l.name},
              onAdd: (uid) => labelRepo.assign(doc.uid, uid),
              onRemove: (uid) => labelRepo.unassign(doc.uid, uid),
              onCreate: (name) async {
                final l = await labelRepo.create(name: name);
                await labelRepo.assign(doc.uid, l.uid);
              },
            ),

            const Divider(height: 28),

            // Actions
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => openDocument(ref, doc),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open'),
                ),
                OutlinedButton.icon(
                  onPressed: () => moveDocument(context, ref, doc),
                  icon: const Icon(Icons.drive_file_move_outline),
                  label: const Text('Move'),
                ),
                OutlinedButton.icon(
                  onPressed: () => duplicateDocument(ref, doc),
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Duplicate'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.error),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await deleteDocument(context, ref, doc);
                    navigator.maybePop();
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _ocrLabel(String status) => switch (status) {
      OcrStatus.pending => 'Queued',
      OcrStatus.running => 'Running…',
      OcrStatus.done => 'Recognized',
      OcrStatus.failed => 'Unavailable / failed',
      _ => 'Not started',
    };

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 0.6,
              )),
    );
  }
}

/// Reusable multi-select chip editor used for both tags and labels.
class _ChipPicker extends StatelessWidget {
  const _ChipPicker({
    required this.title,
    required this.selected,
    required this.available,
    required this.onAdd,
    required this.onRemove,
    required this.onCreate,
  });

  final String title;
  final Map<String, String> selected; // uid -> name
  final Map<String, String> available; // uid -> name
  final void Function(String uid) onAdd;
  final void Function(String uid) onRemove;
  final Future<void> Function(String name) onCreate;

  @override
  Widget build(BuildContext context) {
    final unselected = {
      for (final e in available.entries)
        if (!selected.containsKey(e.key)) e.key: e.value,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final e in selected.entries)
              InputChip(
                label: Text(e.value),
                onDeleted: () => onRemove(e.key),
              ),
            PopupMenuButton<String>(
              tooltip: 'Add $title',
              onSelected: (value) async {
                if (value == '__create__') {
                  final name = await showTextPromptDialog(
                    context,
                    title: 'New ${title.toLowerCase()}',
                    label: 'Name',
                    confirmText: 'Create',
                  );
                  if (name != null && name.isNotEmpty) {
                    await onCreate(name);
                  }
                } else {
                  onAdd(value);
                }
              },
              itemBuilder: (context) => [
                for (final e in unselected.entries)
                  PopupMenuItem(value: e.key, child: Text(e.value)),
                if (unselected.isNotEmpty) const PopupMenuDivider(),
                const PopupMenuItem(
                  value: '__create__',
                  child: Text('Create new…'),
                ),
              ],
              child: Chip(
                avatar: const Icon(Icons.add, size: 18),
                label: Text('Add'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

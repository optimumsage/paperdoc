import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/platform_info.dart';
import '../../../data/db/app_database.dart';
import '../../document_detail/document_detail_sheet.dart';
import '../doc_visuals.dart';
import '../document_actions.dart';
import '../selection_controller.dart';

enum _DocAction {
  open,
  details,
  rename,
  move,
  duplicate,
  extract,
  reveal,
  star,
  delete
}

/// A single document, rendered either as a grid card or a list row.
class DocumentTile extends ConsumerWidget {
  const DocumentTile({required this.doc, this.grid = true, super.key});

  final Document doc;
  final bool grid;

  Future<void> _run(
      _DocAction action, BuildContext context, WidgetRef ref) async {
    switch (action) {
      case _DocAction.open:
        await openDocument(ref, doc);
      case _DocAction.details:
        await showDocumentDetail(context, doc.uid);
      case _DocAction.rename:
        await renameDocument(context, ref, doc);
      case _DocAction.move:
        await moveDocument(context, ref, doc);
      case _DocAction.duplicate:
        await duplicateDocument(ref, doc);
      case _DocAction.extract:
        await extractArchive(context, ref, doc);
      case _DocAction.reveal:
        await revealDocument(ref, doc);
      case _DocAction.star:
        await toggleStar(ref, doc);
      case _DocAction.delete:
        await deleteDocument(context, ref, doc);
    }
  }

  String get _subtitle {
    final ext = (doc.ext ?? '').toUpperCase();
    final size = formatBytes(doc.sizeBytes);
    return ext.isEmpty ? size : '$ext · $size';
  }

  PopupMenuButton<_DocAction> _menuButton(
      BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_DocAction>(
      tooltip: 'Actions',
      icon: const Icon(Icons.more_vert, size: 18),
      onSelected: (a) => _run(a, context, ref),
      itemBuilder: (context) => [
        const PopupMenuItem(value: _DocAction.open, child: Text('Open')),
        const PopupMenuItem(
            value: _DocAction.details, child: Text('Details…')),
        const PopupMenuItem(value: _DocAction.rename, child: Text('Rename')),
        const PopupMenuItem(value: _DocAction.move, child: Text('Move to…')),
        const PopupMenuItem(
            value: _DocAction.duplicate, child: Text('Duplicate')),
        if (doc.docType == 'archive')
          const PopupMenuItem(
              value: _DocAction.extract, child: Text('Extract archive')),
        if (PlatformInfo.isDesktop)
          const PopupMenuItem(
              value: _DocAction.reveal, child: Text('Reveal in file manager')),
        PopupMenuItem(
          value: _DocAction.star,
          child: Text(doc.starred ? 'Remove star' : 'Add star'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(value: _DocAction.delete, child: Text('Delete')),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final accent = docTypeColor(doc.docType, scheme);
    final icon = docTypeIcon(doc.docType);

    final selection = ref.watch(selectionProvider);
    final selectionActive = selection.isNotEmpty;
    final selected = selection.contains(doc.uid);
    final selectionNotifier = ref.read(selectionProvider.notifier);
    void onTap() => selectionActive
        ? selectionNotifier.toggle(doc.uid)
        : _run(_DocAction.open, context, ref);
    void onLongPress() => selectionNotifier.toggle(doc.uid);

    if (!grid) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: selected ? scheme.secondaryContainer : null,
        child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          leading: selected
              ? CircleAvatar(
                  backgroundColor: scheme.primary,
                  child: Icon(Icons.check, color: scheme.onPrimary),
                )
              : CircleAvatar(
                  backgroundColor: accent.withValues(alpha: 0.15),
                  child: Icon(icon, color: accent),
                ),
          title: Text(doc.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(_subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (doc.starred)
                const Icon(Icons.star, size: 16, color: Color(0xFFE0A100)),
              if (!selectionActive) _menuButton(context, ref),
            ],
          ),
        ),
      );
    }

    return Card(
      shape: selected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: scheme.primary, width: 2),
            )
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: accent.withValues(alpha: 0.10),
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Center(child: Icon(icon, size: 44, color: accent)),
                    if (doc.starred)
                      const Positioned(
                        top: 6,
                        left: 6,
                        child: Icon(Icons.star,
                            size: 16, color: Color(0xFFE0A100)),
                      ),
                    if (selected)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: scheme.primary,
                          child: Icon(Icons.check,
                              size: 14, color: scheme.onPrimary),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 2, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          _subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  if (!selectionActive) _menuButton(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

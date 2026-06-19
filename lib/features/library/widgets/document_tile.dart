import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/platform_info.dart';
import '../../../data/db/app_database.dart';
import '../../document_detail/document_detail_sheet.dart';
import '../../sync/sync_controller.dart';
import '../doc_visuals.dart';
import '../document_actions.dart';
import '../export_actions.dart';
import '../selection_controller.dart';

enum _DocAction {
  open,
  details,
  rename,
  move,
  duplicate,
  download,
  extract,
  reveal,
  star,
  keepOffline,
  freeUpSpace,
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
      case _DocAction.download:
        await exportDocument(context, ref, doc);
      case _DocAction.extract:
        await extractArchive(context, ref, doc);
      case _DocAction.reveal:
        await revealDocument(ref, doc);
      case _DocAction.star:
        await toggleStar(ref, doc);
      case _DocAction.keepOffline:
        await keepOffline(context, ref, doc);
      case _DocAction.freeUpSpace:
        await freeUpSpace(context, ref, doc);
      case _DocAction.delete:
        await deleteDocument(context, ref, doc);
    }
  }

  /// A small cloud/spinner badge for cloud-only or downloading documents.
  Widget? _availabilityIndicator(ColorScheme scheme) {
    switch (doc.downloadState) {
      case 'cloud':
        return Icon(Icons.cloud_outlined,
            size: 16, color: scheme.onSurfaceVariant);
      case 'downloading':
        return const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      default:
        return null;
    }
  }

  String get _subtitle {
    final ext = (doc.ext ?? '').toUpperCase();
    final size = formatBytes(doc.sizeBytes);
    return ext.isEmpty ? size : '$ext · $size';
  }

  /// The action menu, shared between the overflow button and the right-click /
  /// long-press context menu.
  List<PopupMenuEntry<_DocAction>> _menuItems(WidgetRef ref) {
    final syncConnected = ref.watch(syncControllerProvider).connected;
    return [
      const PopupMenuItem(value: _DocAction.open, child: Text('Open')),
      const PopupMenuItem(value: _DocAction.details, child: Text('Details…')),
      const PopupMenuItem(value: _DocAction.rename, child: Text('Rename')),
      const PopupMenuItem(value: _DocAction.move, child: Text('Move to…')),
      const PopupMenuItem(
          value: _DocAction.duplicate, child: Text('Duplicate')),
      const PopupMenuItem(
          value: _DocAction.download, child: Text('Download a copy…')),
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
      if (doc.downloadState != 'local')
        const PopupMenuItem(
            value: _DocAction.keepOffline, child: Text('Keep offline')),
      if (doc.downloadState == 'local' && syncConnected)
        const PopupMenuItem(
            value: _DocAction.freeUpSpace, child: Text('Free up space')),
      const PopupMenuDivider(),
      const PopupMenuItem(value: _DocAction.delete, child: Text('Delete')),
    ];
  }

  PopupMenuButton<_DocAction> _menuButton(
      BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_DocAction>(
      tooltip: 'Actions',
      icon: const Icon(Icons.more_vert, size: 18),
      onSelected: (a) => _run(a, context, ref),
      itemBuilder: (context) => _menuItems(ref),
    );
  }

  /// Opens the action menu at [position] (used for desktop right-click and
  /// mobile long-press, since tap is reserved for selection).
  Future<void> _showContextMenu(
      BuildContext context, WidgetRef ref, Offset position) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final action = await showMenu<_DocAction>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: _menuItems(ref),
    );
    if (action != null && context.mounted) {
      await _run(action, context, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final accent = docTypeColor(doc.docType, scheme);
    final icon = docTypeIcon(doc.docType);

    final selection = ref.watch(selectionProvider);
    final selected = selection.contains(doc.uid);
    final selectionNotifier = ref.read(selectionProvider.notifier);

    // Single tap selects (and toggles), double tap opens, and the action menu
    // is reached via right-click (desktop) or long-press (mobile). The InkWell
    // must stay inside the Card so it has a Material ancestor for its ripple.
    Widget gestures(Widget child) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onSecondaryTapDown: PlatformInfo.isDesktop
              ? (d) => _showContextMenu(context, ref, d.globalPosition)
              : null,
          onLongPressStart: (d) =>
              _showContextMenu(context, ref, d.globalPosition),
          child: InkWell(
            onTap: () => selectionNotifier.toggle(doc.uid),
            onDoubleTap: () => _run(_DocAction.open, context, ref),
            child: child,
          ),
        );

    if (!grid) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: selected ? scheme.secondaryContainer : null,
        child: gestures(ListTile(
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
              if (_availabilityIndicator(scheme) case final indicator?)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: indicator,
                ),
              if (doc.starred)
                const Icon(Icons.star, size: 16, color: Color(0xFFE0A100)),
              _menuButton(context, ref),
            ],
          ),
        )),
      );
    }

    return Card(
      shape: selected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: scheme.primary, width: 2),
            )
          : null,
      child: gestures(
        Column(
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
                    if (_availabilityIndicator(scheme) case final indicator?)
                      Positioned(bottom: 6, right: 6, child: indicator),
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
                  _menuButton(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../data/db/app_database.dart';

/// Result of the "move to folder" picker. A null [folderUid] means "unfiled".
/// A null return from the dialog means the user cancelled.
class MoveResult {
  const MoveResult(this.folderUid);
  final String? folderUid;
}

Future<String?> showTextPromptDialog(
  BuildContext context, {
  required String title,
  required String label,
  String initialValue = '',
  String confirmText = 'Save',
}) {
  final controller = TextEditingController(text: initialValue);
  controller.selection =
      TextSelection(baseOffset: 0, extentOffset: initialValue.length);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: label),
          onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(controller.text.trim()),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}

Future<MoveResult?> showMoveToFolderDialog(
  BuildContext context, {
  required List<Folder> folders,
  String? currentFolderUid,
}) {
  return showDialog<MoveResult>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text('Move to folder'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(const MoveResult(null)),
            child: const ListTile(
              leading: Icon(Icons.inbox_outlined),
              title: Text('Unfiled'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          for (final folder in folders)
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.of(context).pop(MoveResult(folder.uid)),
              child: ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(folder.name),
                trailing: folder.uid == currentFolderUid
                    ? const Icon(Icons.check)
                    : null,
                contentPadding: EdgeInsets.zero,
              ),
            ),
        ],
      );
    },
  );
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Delete',
  bool destructive = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return result ?? false;
}

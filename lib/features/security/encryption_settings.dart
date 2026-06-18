import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'library_lock_controller.dart';

/// Settings control for per-library encryption: enable it (with a master
/// password) or lock the unlocked library.
class EncryptionSettings extends ConsumerWidget {
  const EncryptionSettings({super.key});

  Future<void> _enable(BuildContext context, WidgetRef ref) async {
    final password = await showDialog<String>(
      context: context,
      builder: (_) => const _SetPasswordDialog(),
    );
    if (password != null && password.isNotEmpty) {
      await ref.read(libraryLockProvider.notifier).enable(password);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lock = ref.watch(libraryLockProvider);

    if (lock.loading) {
      return const ListTile(
        leading: Icon(Icons.lock_outline),
        title: Text('Encryption'),
        subtitle: Text('…'),
      );
    }

    if (!lock.encrypted) {
      return ListTile(
        leading: const Icon(Icons.lock_open_outlined),
        title: const Text('Encrypt this library'),
        subtitle: const Text(
            'Protect documents with a master password (cannot be recovered if forgotten)'),
        trailing: FilledButton(
          onPressed: () => _enable(context, ref),
          child: const Text('Encrypt'),
        ),
      );
    }

    return ListTile(
      leading: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
      title: const Text('Library is encrypted'),
      subtitle: Text(lock.unlocked ? 'Unlocked' : 'Locked'),
      trailing: lock.unlocked
          ? OutlinedButton(
              onPressed: () => ref.read(libraryLockProvider.notifier).lockNow(),
              child: const Text('Lock now'),
            )
          : null,
    );
  }
}

class _SetPasswordDialog extends StatefulWidget {
  const _SetPasswordDialog();

  @override
  State<_SetPasswordDialog> createState() => _SetPasswordDialogState();
}

class _SetPasswordDialogState extends State<_SetPasswordDialog> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_password.text.length < 6) {
      setState(() => _error = 'Use at least 6 characters.');
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    Navigator.of(context).pop(_password.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set master password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'This password encrypts your library. If you lose it, your '
            'documents cannot be recovered.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Master password'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _confirm,
            obscureText: true,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Confirm password',
              errorText: _error,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Encrypt')),
      ],
    );
  }
}

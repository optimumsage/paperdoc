import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'sync_controller.dart';

/// Settings UI to connect Google Drive with bring-your-own OAuth credentials,
/// trigger a sync, and disconnect.
class DriveSyncSettings extends ConsumerStatefulWidget {
  const DriveSyncSettings({super.key});

  @override
  ConsumerState<DriveSyncSettings> createState() => _DriveSyncSettingsState();
}

class _DriveSyncSettingsState extends ConsumerState<DriveSyncSettings> {
  final _idController = TextEditingController();
  final _secretController = TextEditingController();
  final _onboardController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _secretController.dispose();
    _onboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(syncControllerProvider);
    final controller = ref.read(syncControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          leading: Icon(Icons.cloud_outlined),
          title: Text('Google Drive'),
          subtitle: Text('Two-way sync to a dedicated PaperDoc folder'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.needsPassword) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('This cloud library is encrypted. Enter the '
                          'master password to unlock it on this device.'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _onboardController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Master password'),
                        onSubmitted: (v) =>
                            controller.submitOnboardingPassword(v),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: state.busy
                                ? null
                                : () => controller.submitOnboardingPassword(
                                    _onboardController.text),
                            child: const Text('Unlock & sync'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: controller.cancelOnboarding,
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (state.connected) ...[
                Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: scheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Connected${state.accountLabel != null ? ' · ${state.accountLabel}' : ''}'
                        '${state.lastSyncAt != null ? '\nLast sync: ${_fmt(state.lastSyncAt!)}' : ''}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: state.busy ? null : controller.syncNow,
                      icon: const Icon(Icons.sync),
                      label: const Text('Sync now'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: state.busy ? null : controller.disconnect,
                      child: const Text('Disconnect'),
                    ),
                  ],
                ),
              ] else ...[
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'OAuth client ID',
                    hintText: 'xxxxxxxx.apps.googleusercontent.com',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _secretController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'OAuth client secret'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: state.busy
                          ? null
                          : () => controller.saveCredentials(
                                _idController.text,
                                _secretController.text,
                              ),
                      child: const Text('Save credentials'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed:
                          state.busy || !state.hasCredentials ? null : controller.connect,
                      icon: const Icon(Icons.link),
                      label: const Text('Connect'),
                    ),
                  ],
                ),
                if (state.hasCredentials)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Credentials saved ✓',
                        style: TextStyle(color: scheme.primary)),
                  ),
              ],
              if (state.busy)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: LinearProgressIndicator(),
                ),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(state.error!,
                      style: TextStyle(color: scheme.error)),
                ),
              if (state.lastReport != null && !state.busy)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(state.lastReport!,
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Credentials are encrypted at rest with an app-managed key.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _fmt(int ms) =>
      DateFormat.yMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(ms));
}

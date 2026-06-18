import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_providers.dart';
import '../duplicates/duplicates_page.dart';
import '../security/encryption_settings.dart';
import '../sync/drive_sync_settings.dart';
import '../update/update_settings.dart';
import '../watch/watch_settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (mode) {
              if (mode != null) {
                ref.read(themeModeProvider.notifier).set(mode);
              }
            },
            child: const Column(
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  title: Text('Follow system'),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  title: Text('Light'),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  title: Text('Dark'),
                ),
              ],
            ),
          ),
          const Divider(),
          const _SectionHeader('Security'),
          const EncryptionSettings(),
          const Divider(),
          const _SectionHeader('Watch Folders'),
          const WatchSettings(),
          const Divider(),
          const _SectionHeader('Cloud Sync'),
          const DriveSyncSettings(),
          const Divider(),
          const _SectionHeader('Tools'),
          ListTile(
            leading: const Icon(Icons.content_copy_outlined),
            title: const Text('Find duplicates'),
            subtitle: const Text('Identical files by content'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const DuplicatesPage(),
              ),
            ),
          ),
          const Divider(),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('PaperDoc'),
            subtitle: Text('v0.1.0 — offline document organizer'),
          ),
          const UpdateSettings(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}

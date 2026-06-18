import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/repositories/providers.dart';
import '../../services/update/update_service.dart';

/// Settings control to check for and install app updates from GitHub Releases.
class UpdateSettings extends ConsumerStatefulWidget {
  const UpdateSettings({super.key});

  @override
  ConsumerState<UpdateSettings> createState() => _UpdateSettingsState();
}

class _UpdateSettingsState extends ConsumerState<UpdateSettings> {
  bool _busy = false;
  String? _message;
  UpdateInfo? _update;

  Future<void> _check() async {
    setState(() {
      _busy = true;
      _message = null;
      _update = null;
    });
    try {
      final info = await ref.read(updateServiceProvider).checkForUpdate();
      setState(() {
        _update = info;
        _message = info == null ? "You're on the latest version." : null;
      });
    } catch (e) {
      setState(() => _message = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _install() async {
    final info = _update;
    if (info == null) return;
    setState(() => _busy = true);
    try {
      if (info.hasAsset) {
        await ref.read(updateServiceProvider).downloadAndInstall(info);
      } else {
        await launchUrl(Uri.parse(info.releaseUrl),
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      setState(() => _message = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.system_update_alt),
          title: const Text('Updates'),
          subtitle: Text(_update != null
              ? 'Update available: ${_update!.version}'
              : 'Check GitHub for a new version'),
          trailing: _busy
              ? const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : TextButton(
                  onPressed: _check,
                  child: const Text('Check'),
                ),
        ),
        if (_update != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: FilledButton.icon(
              onPressed: _busy ? null : _install,
              icon: const Icon(Icons.download),
              label: Text(_update!.hasAsset
                  ? 'Download & install ${_update!.version}'
                  : 'Open release page'),
            ),
          ),
        if (_message != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(_message!,
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
      ],
    );
  }
}

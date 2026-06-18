import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../core/platform_info.dart';
import '../../data/repositories/providers.dart';
import '../library/import_actions.dart';

/// On Android, intercepts files shared into the app ("Share → PaperDoc") and
/// imports them into the library. No-op on other platforms. Mounted high in the
/// widget tree so it works regardless of the current screen.
class ShareIntake extends ConsumerStatefulWidget {
  const ShareIntake({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ShareIntake> createState() => _ShareIntakeState();
}

class _ShareIntakeState extends ConsumerState<ShareIntake> {
  StreamSubscription<List<SharedMediaFile>>? _sub;

  @override
  void initState() {
    super.initState();
    if (!PlatformInfo.isAndroid) return;
    final intent = ReceiveSharingIntent.instance;
    // Files shared while the app was closed.
    intent.getInitialMedia().then((files) {
      _import(files);
      intent.reset();
    }).catchError((_) {});
    // Files shared while the app is running. onError keeps a missing plugin
    // (tests / unsupported setups) from crashing.
    _sub = intent.getMediaStream().listen(_import, onError: (_) {});
  }

  Future<void> _import(List<SharedMediaFile> files) async {
    final paths = [for (final f in files) f.path];
    if (paths.isEmpty) return;
    final messenger = ScaffoldMessenger.maybeOf(context);

    final root = await ref.read(libraryServiceProvider).currentRoot();
    if (root == null) {
      messenger?.showSnackBar(const SnackBar(
        content: Text('Set up your library first, then share again.'),
      ));
      return;
    }
    try {
      final n = await importPaths(ref, paths);
      messenger?.showSnackBar(
        SnackBar(content: Text('Imported $n shared file(s)')),
      );
    } catch (e) {
      messenger?.showSnackBar(
        SnackBar(content: Text('Share import failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

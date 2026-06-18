import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/providers.dart';

class LockState {
  const LockState({
    this.encrypted = false,
    this.unlocked = false,
    this.loading = true,
  });

  final bool encrypted;
  final bool unlocked;
  final bool loading;

  /// True when the UI should gate access behind the unlock screen.
  bool get locked => encrypted && !unlocked;

  LockState copyWith({bool? encrypted, bool? unlocked, bool? loading}) =>
      LockState(
        encrypted: encrypted ?? this.encrypted,
        unlocked: unlocked ?? this.unlocked,
        loading: loading ?? this.loading,
      );
}

/// Reactive view of the library's encryption/lock state for the UI. Delegates
/// the actual key work to the [LibraryEncryption] singleton.
class LibraryLockController extends Notifier<LockState> {
  @override
  LockState build() {
    _load();
    return const LockState();
  }

  Future<void> _load() async {
    final enc = ref.read(libraryEncryptionProvider);
    state = LockState(
      encrypted: await enc.isEncrypted(),
      unlocked: enc.isUnlocked,
      loading: false,
    );
  }

  Future<void> enable(String password) async {
    await ref.read(libraryEncryptionProvider).enable(password);
    state = const LockState(encrypted: true, unlocked: true, loading: false);
  }

  Future<bool> unlock(String password) async {
    final ok = await ref.read(libraryEncryptionProvider).unlock(password);
    if (ok) {
      state = const LockState(encrypted: true, unlocked: true, loading: false);
    }
    return ok;
  }

  void lockNow() {
    ref.read(libraryEncryptionProvider).lock();
    state = state.copyWith(unlocked: false);
  }
}

final libraryLockProvider =
    NotifierProvider<LibraryLockController, LockState>(
  LibraryLockController.new,
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the set of selected document uids for multi-select. A non-empty set
/// puts the library into "selection mode" (contextual action bar, tile taps
/// toggle selection instead of opening).
class SelectionController extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  bool isSelected(String uid) => state.contains(uid);

  void toggle(String uid) {
    final next = {...state};
    next.contains(uid) ? next.remove(uid) : next.add(uid);
    state = next;
  }

  void selectAll(Iterable<String> uids) => state = {...uids};

  void clear() => state = const {};
}

final selectionProvider =
    NotifierProvider<SelectionController, Set<String>>(SelectionController.new);

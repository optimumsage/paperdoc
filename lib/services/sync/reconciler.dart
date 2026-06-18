/// What to do with one rel path after comparing local, remote, and the
/// last-synced base.
enum SyncOp { upload, download, deleteRemote, deleteLocal, conflict }

class SyncAction {
  const SyncAction(this.relPath, this.op, {this.remoteId});

  final String relPath;
  final SyncOp op;

  /// Remote file id, when the action targets an existing remote file
  /// (download, deleteRemote, conflict download).
  final String? remoteId;

  @override
  String toString() => 'SyncAction($relPath, $op)';
}

/// Local blob known to the engine: its rel path and current content hash.
class LocalEntry {
  const LocalEntry(this.relPath, this.hash);
  final String relPath;
  final String hash;
}

/// Remote blob from [CloudProvider.listFiles].
class RemoteEntry {
  const RemoteEntry(this.relPath, this.id, this.hash);
  final String relPath;
  final String id;
  final String hash;
}

/// The last-synced state for a rel path (from the sync_state table).
class BaseEntry {
  const BaseEntry(this.relPath, this.baseHash);
  final String relPath;
  final String baseHash;
}

/// Pure three-way reconciliation over the union of local, remote, and base
/// entries. File bytes are never resolved by last-writer-wins: a real
/// divergence (or delete-vs-edit) yields [SyncOp.conflict], which the engine
/// resolves by keeping both copies. Convergent edits (both sides became the
/// same content) need no action and just advance the base.
List<SyncAction> reconcile({
  required List<LocalEntry> local,
  required List<RemoteEntry> remote,
  required List<BaseEntry> base,
}) {
  final localMap = {for (final e in local) e.relPath: e};
  final remoteMap = {for (final e in remote) e.relPath: e};
  final baseMap = {for (final e in base) e.relPath: e};

  final paths = <String>{
    ...localMap.keys,
    ...remoteMap.keys,
    ...baseMap.keys,
  };

  final actions = <SyncAction>[];
  for (final path in paths) {
    final localHash = localMap[path]?.hash;
    final remoteEntry = remoteMap[path];
    final remoteHash = remoteEntry?.hash;
    final baseHash = baseMap[path]?.baseHash;

    // Already identical on both sides (incl. both absent) — nothing to do.
    if (localHash == remoteHash) continue;

    final localChanged = localHash != baseHash;
    final remoteChanged = remoteHash != baseHash;

    if (localChanged && !remoteChanged) {
      actions.add(localHash == null
          ? SyncAction(path, SyncOp.deleteRemote, remoteId: remoteEntry?.id)
          : SyncAction(path, SyncOp.upload));
    } else if (!localChanged && remoteChanged) {
      actions.add(remoteHash == null
          ? SyncAction(path, SyncOp.deleteLocal)
          : SyncAction(path, SyncOp.download, remoteId: remoteEntry?.id));
    } else {
      // Both diverged from base in different directions → conflict
      // (covers edit-vs-edit and delete-vs-edit).
      actions.add(SyncAction(path, SyncOp.conflict, remoteId: remoteEntry?.id));
    }
  }
  return actions;
}

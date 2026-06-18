import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/services/sync/reconciler.dart';

SyncAction? actionFor(
  String path, {
  List<LocalEntry> local = const [],
  List<RemoteEntry> remote = const [],
  List<BaseEntry> base = const [],
}) {
  final actions =
      reconcile(local: local, remote: remote, base: base);
  final matching = actions.where((a) => a.relPath == path).toList();
  return matching.isEmpty ? null : matching.single;
}

void main() {
  const path = 'files/ab/doc.pdf';

  test('new local file → upload', () {
    final a = actionFor(path, local: [const LocalEntry(path, 'h1')]);
    expect(a?.op, SyncOp.upload);
  });

  test('new remote file → download', () {
    final a = actionFor(path, remote: [const RemoteEntry(path, 'r1', 'h1')]);
    expect(a?.op, SyncOp.download);
    expect(a?.remoteId, 'r1');
  });

  test('unchanged on both sides → no action', () {
    final a = actionFor(
      path,
      local: [const LocalEntry(path, 'h1')],
      remote: [const RemoteEntry(path, 'r1', 'h1')],
      base: [const BaseEntry(path, 'h1')],
    );
    expect(a, isNull);
  });

  test('local edited, remote unchanged → upload', () {
    final a = actionFor(
      path,
      local: [const LocalEntry(path, 'h2')],
      remote: [const RemoteEntry(path, 'r1', 'h1')],
      base: [const BaseEntry(path, 'h1')],
    );
    expect(a?.op, SyncOp.upload);
  });

  test('remote edited, local unchanged → download', () {
    final a = actionFor(
      path,
      local: [const LocalEntry(path, 'h1')],
      remote: [const RemoteEntry(path, 'r1', 'h2')],
      base: [const BaseEntry(path, 'h1')],
    );
    expect(a?.op, SyncOp.download);
  });

  test('both edited to the same content → converged, no action', () {
    final a = actionFor(
      path,
      local: [const LocalEntry(path, 'h2')],
      remote: [const RemoteEntry(path, 'r1', 'h2')],
      base: [const BaseEntry(path, 'h1')],
    );
    expect(a, isNull);
  });

  test('both edited differently → conflict', () {
    final a = actionFor(
      path,
      local: [const LocalEntry(path, 'h2')],
      remote: [const RemoteEntry(path, 'r1', 'h3')],
      base: [const BaseEntry(path, 'h1')],
    );
    expect(a?.op, SyncOp.conflict);
  });

  test('local deleted, remote unchanged → delete remote', () {
    final a = actionFor(
      path,
      remote: [const RemoteEntry(path, 'r1', 'h1')],
      base: [const BaseEntry(path, 'h1')],
    );
    expect(a?.op, SyncOp.deleteRemote);
    expect(a?.remoteId, 'r1');
  });

  test('remote deleted, local unchanged → delete local', () {
    final a = actionFor(
      path,
      local: [const LocalEntry(path, 'h1')],
      base: [const BaseEntry(path, 'h1')],
    );
    expect(a?.op, SyncOp.deleteLocal);
  });

  test('both deleted → no action', () {
    final a = actionFor(path, base: [const BaseEntry(path, 'h1')]);
    expect(a, isNull);
  });

  test('remote edited while local deleted → conflict', () {
    final a = actionFor(
      path,
      remote: [const RemoteEntry(path, 'r1', 'h2')],
      base: [const BaseEntry(path, 'h1')],
    );
    expect(a?.op, SyncOp.conflict);
  });
}

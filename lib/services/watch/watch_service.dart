import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';

import '../../core/clock.dart';
import '../../core/doc_type.dart';
import '../../core/hashing.dart';
import '../../data/db/app_database.dart';

/// Scans watched directories for new document files and records suggestions to
/// add them to the library. Runs on demand, when the app opens / resumes, and
/// (best-effort) live via filesystem watchers. Files already in the library (by
/// content hash) or already suggested for the same path+content are skipped;
/// suggestions for files that have since disappeared are pruned so a re-added
/// same-named file is detected again.
class WatchService {
  WatchService(this._db, {Clock clock = const SystemClock()}) : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  final List<StreamSubscription<WatchEvent>> _subs = [];
  final Map<String, Timer> _debounce = {};

  /// (Re)starts live filesystem watchers for every enabled directory. Safe to
  /// call repeatedly — existing watchers are torn down first. Watch failures
  /// (e.g. Android scoped-storage paths) degrade silently to manual/resume
  /// scans.
  Future<void> startWatching() async {
    await stopWatching();
    final dirs =
        await (_db.select(_db.watchDirs)..where((t) => t.enabled.equals(true)))
            .get();
    for (final dir in dirs) {
      try {
        if (!Directory(dir.path).existsSync()) continue;
        final watcher = DirectoryWatcher(dir.path);
        _subs.add(watcher.events.listen((_) => _scheduleScan(dir)));
      } catch (_) {
        // Unwatchable path — rely on manual + resume scans for this dir.
      }
    }
  }

  /// Cancels all live watchers and pending debounced scans.
  Future<void> stopWatching() async {
    for (final t in _debounce.values) {
      t.cancel();
    }
    _debounce.clear();
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
  }

  /// Coalesces a burst of filesystem events into a single scan ~2s later.
  void _scheduleScan(WatchDir dir) {
    _debounce[dir.path]?.cancel();
    _debounce[dir.path] =
        Timer(const Duration(seconds: 2), () => scanDir(dir));
  }

  Future<int> scanAll() async {
    final dirs =
        await (_db.select(_db.watchDirs)..where((t) => t.enabled.equals(true)))
            .get();
    var total = 0;
    for (final dir in dirs) {
      total += await scanDir(dir);
    }
    return total;
  }

  Future<int> scanDir(WatchDir dir) async {
    final root = Directory(dir.path);
    if (!await root.exists()) return 0;

    // Drop suggestions whose source file has disappeared, so a file that was
    // deleted and re-added under the same name isn't blocked by a stale row.
    await _pruneMissing(dir);

    var created = 0;
    final entities = root.list(recursive: dir.recursive, followLinks: false);
    await for (final entity in entities) {
      if (entity is! File) continue;
      final name = p.basename(entity.path);
      if (name.startsWith('.')) continue;
      final ext = p.extension(name).replaceFirst('.', '').toLowerCase();
      if (!_included(ext, dir.globInclude)) continue;

      final hash = await sha256OfFile(entity);

      // Already surfaced *this exact file* (same path + content)? Skip. If the
      // path was reused for different content, drop the stale row and re-surface.
      final existing = await (_db.select(_db.watchSuggestions)
            ..where((t) => t.srcPath.equals(entity.path)))
          .getSingleOrNull();
      if (existing != null) {
        if (existing.fileHash == hash) continue;
        await (_db.delete(_db.watchSuggestions)
              ..where((t) => t.id.equals(existing.id)))
            .go();
      }

      // Skip files already present in the library.
      final inLibrary = await (_db.select(_db.documents)
            ..where((t) =>
                t.contentHash.equals(hash) & t.deleted.equals(false)))
          .getSingleOrNull();
      if (inLibrary != null) continue;

      await _db.into(_db.watchSuggestions).insert(
            WatchSuggestionsCompanion.insert(
              srcPath: entity.path,
              detectedAt: _clock.nowMs(),
              fileHash: Value(hash),
              suggestedFolderUid: Value(dir.defaultFolderUid),
            ),
          );
      created++;
    }
    return created;
  }

  /// Deletes suggestion rows under [dir] whose source file no longer exists.
  Future<void> _pruneMissing(WatchDir dir) async {
    final rows = await _db.select(_db.watchSuggestions).get();
    for (final row in rows) {
      if (!row.srcPath.startsWith(dir.path)) continue;
      if (!File(row.srcPath).existsSync()) {
        await (_db.delete(_db.watchSuggestions)
              ..where((t) => t.id.equals(row.id)))
            .go();
      }
    }
  }

  /// Default include = recognized document types; otherwise match a
  /// `*.ext;*.ext2` glob list.
  bool _included(String ext, String? globInclude) {
    if (globInclude == null || globInclude.trim().isEmpty) {
      return DocType.fromExtension(ext) != DocType.other;
    }
    for (final raw in globInclude.split(';')) {
      final pattern = raw.trim().toLowerCase();
      if (pattern == '*' || pattern == '*.*') return true;
      if (pattern.startsWith('*.') && pattern.substring(2) == ext) return true;
    }
    return false;
  }
}

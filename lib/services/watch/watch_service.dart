import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../core/clock.dart';
import '../../core/doc_type.dart';
import '../../core/hashing.dart';
import '../../data/db/app_database.dart';

/// Scans watched directories for new document files and records suggestions to
/// add them to the library. Scan-based (not live FS events) for reliability and
/// testability; runs on demand and when the app opens. Files already in the
/// library (by content hash) or already suggested/dismissed are skipped.
class WatchService {
  WatchService(this._db, {Clock clock = const SystemClock()}) : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

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

    var created = 0;
    final entities = root.list(recursive: dir.recursive, followLinks: false);
    await for (final entity in entities) {
      if (entity is! File) continue;
      final name = p.basename(entity.path);
      if (name.startsWith('.')) continue;
      final ext = p.extension(name).replaceFirst('.', '').toLowerCase();
      if (!_included(ext, dir.globInclude)) continue;

      // Skip anything already surfaced (pending/accepted/dismissed).
      final existing = await (_db.select(_db.watchSuggestions)
            ..where((t) => t.srcPath.equals(entity.path)))
          .getSingleOrNull();
      if (existing != null) continue;

      // Skip files already present in the library.
      final hash = await sha256OfFile(entity);
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

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/db/app_database.dart';

/// Owns the on-disk layout of a managed library. The library is a single root
/// folder containing a `files/` tree of content blobs, addressed by document
/// uid and bucketed by the uid's first two characters to keep directories
/// small. The catalog DB (separate) holds all metadata.
///
/// This service is filesystem-only — it never touches the `documents` table.
/// [ImportService] coordinates blob placement with catalog rows.
class LibraryService {
  LibraryService(this._db);

  final AppDatabase _db;
  String? _root;

  static const _kRootKey = 'library_root';

  /// The currently configured library root, or null if none has been chosen.
  Future<String?> currentRoot() async => _root ??= await _db.getSetting(_kRootKey);

  /// Default library location under the OS documents directory. Always writable
  /// with no permissions — the right choice on Android (scoped storage) and a
  /// sensible default on desktop.
  Future<String> defaultRootPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'PaperDoc');
  }

  bool get hasRoot => _root != null;

  /// Selects (and creates) the library root, persisting it to settings.
  Future<void> setRoot(String path) async {
    await Directory(p.join(path, 'files')).create(recursive: true);
    await _db.setSetting(_kRootKey, path);
    _root = path;
  }

  /// POSIX-style relative path for a blob (forward slashes, so the same value
  /// round-trips through cloud storage regardless of host OS).
  String relPathFor(String uid, String? ext) {
    final bucket = uid.substring(0, 2);
    final hasExt = ext != null && ext.isNotEmpty;
    final name = hasExt ? '$uid.$ext' : uid;
    return 'files/$bucket/$name';
  }

  /// Absolute on-disk path for a blob, ensuring the root is loaded first.
  /// Used by "open with OS" where the service may not have been touched yet.
  Future<String> blobAbsolutePath(String relPath) async {
    await currentRoot();
    return blobFile(relPath).path;
  }

  /// Resolves a stored rel path to a host [File] under the current root.
  File blobFile(String relPath) {
    final root = _root;
    if (root == null) {
      throw StateError('No library root configured');
    }
    return File(p.joinAll([root, ...relPath.split('/')]));
  }

  /// Places a source file into the library at [relPath]. With [move] true the
  /// original is removed (falling back to copy+delete across filesystems).
  Future<File> placeBlob({
    required String sourcePath,
    required String relPath,
    required bool move,
  }) async {
    final dest = blobFile(relPath);
    await dest.parent.create(recursive: true);
    final src = File(sourcePath);
    if (move) {
      try {
        return await src.rename(dest.path);
      } on FileSystemException {
        final copied = await src.copy(dest.path);
        await src.delete();
        return copied;
      }
    }
    return src.copy(dest.path);
  }

  /// Copies an existing library blob to a new rel path (used by document copy).
  Future<File> copyBlob({required String fromRelPath, required String toRelPath}) async {
    final dest = blobFile(toRelPath);
    await dest.parent.create(recursive: true);
    return blobFile(fromRelPath).copy(dest.path);
  }

  /// Permanently removes a blob from disk. No-op if already gone.
  Future<void> deleteBlob(String relPath) async {
    final f = blobFile(relPath);
    if (await f.exists()) {
      await f.delete();
    }
  }
}

/// A file as it exists in the remote store, addressed by its rel path within
/// the synced root folder.
class RemoteFile {
  const RemoteFile({
    required this.id,
    required this.relPath,
    required this.hash,
    this.size,
    this.modifiedMs,
  });

  final String id;
  final String relPath;

  /// Provider-reported content hash (Drive md5Checksum, Graph quickXorHash…).
  final String? hash;
  final int? size;
  final int? modifiedMs;
}

/// Abstraction over a cloud file store scoped to a dedicated app folder. The
/// sync engine talks only to this; concrete providers (Google Drive in M5,
/// OneDrive in M6b) implement it. Encryption happens above this layer — a
/// provider only ever sees opaque bytes.
abstract interface class CloudProvider {
  String get name;

  /// Ensures the dedicated root folder exists; returns its remote id.
  Future<String> ensureRoot();

  /// Lists every file under the synced root.
  Future<List<RemoteFile>> listFiles();

  /// Downloads [file] to [localPath].
  Future<void> download(RemoteFile file, String localPath);

  /// Uploads the file at [localPath] to [relPath]. Pass [existingId] to
  /// overwrite an existing remote file rather than create a new one.
  Future<RemoteFile> upload({
    required String localPath,
    required String relPath,
    String? existingId,
  });

  /// Permanently removes the remote file with [id].
  Future<void> delete(String id);
}

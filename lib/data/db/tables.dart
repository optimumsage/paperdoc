import 'package:drift/drift.dart';

/// Catalog schema (M1). Every syncable entity carries a stable [uid] (the
/// cross-device identity used by sync in M5), wall-clock [createdAt]/[updatedAt]
/// in epoch milliseconds, a [deleted] soft-delete tombstone, and a [revision]
/// counter. The autoincrement `id` is local-only and never leaves this device.
///
/// `updatedAt` is plain wall-clock for now; M5 swaps in a hybrid logical clock
/// for conflict-free ordering across devices without touching call sites.

mixin _SyncableColumns on Table {
  TextColumn get uid => text().unique()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  IntColumn get revision => integer().withDefault(const Constant(0))();
}

class Folders extends Table with _SyncableColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get parentUid => text().nullable()();
  TextColumn get name => text()();
  TextColumn get color => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Categories extends Table with _SyncableColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
}

class Tags extends Table with _SyncableColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().nullable()();
}

class Labels extends Table with _SyncableColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().nullable()();

  /// e.g. 'status', 'priority' — lets the UI render constrained label sets
  /// differently from free-form tags.
  TextColumn get kind => text().nullable()();
}

class Documents extends Table with _SyncableColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get folderUid => text().nullable()();
  TextColumn get categoryUid => text().nullable()();

  TextColumn get title => text()();
  TextColumn get originalName => text()();
  TextColumn get ext => text().nullable()();
  TextColumn get mime => text().nullable()();

  /// Normalized bucket: pdf | image | office | archive | text | other.
  TextColumn get docType => text().withDefault(const Constant('other'))();

  /// Path under the library root, e.g. `files/ab/<uid>.pdf`.
  TextColumn get relPath => text()();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();

  /// sha256 of the plaintext bytes (stable identity for dedup).
  TextColumn get contentHash => text()();

  /// sha256 of the on-disk (possibly encrypted) blob — what the cloud sees.
  TextColumn get encHash => text().nullable()();
  BoolColumn get isEncrypted =>
      boolean().withDefault(const Constant(false))();

  /// none | pending | running | done | failed | not_needed
  TextColumn get ocrStatus => text().withDefault(const Constant('none'))();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();

  IntColumn get importedAt => integer()();
  IntColumn get fileMtime => integer().nullable()();
  IntColumn get deletedAt => integer().nullable()();
}

/// M:N document↔tag. Tombstoned per-row so tag removals propagate via sync.
class DocumentTags extends Table {
  TextColumn get documentUid => text()();
  TextColumn get tagUid => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {documentUid, tagUid};
}

class DocumentLabels extends Table {
  TextColumn get documentUid => text()();
  TextColumn get labelUid => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {documentUid, labelUid};
}

/// Extra bookkeeping for trashed documents. Trash itself is just
/// `documents WHERE deleted = true`; this holds restore + purge metadata.
class TrashMeta extends Table {
  TextColumn get documentUid => text()();
  IntColumn get trashedAt => integer()();
  TextColumn get originFolderUid => text().nullable()();
  IntColumn get purgeAfter => integer().nullable()();
  BoolColumn get remoteDeleted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {documentUid};
}

/// A configured cloud account (one row per connected provider login). M5
/// targets Google Drive; OneDrive reuses the same shape (M6b).
class SyncAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get provider => text()(); // 'gdrive' | 'onedrive'
  TextColumn get accountId => text()();
  TextColumn get displayName => text().nullable()();

  /// Remote id of the app's dedicated root folder.
  TextColumn get rootRemoteId => text().nullable()();

  /// Provider delta cursor (Drive changes pageToken / Graph deltaLink).
  TextColumn get deltaToken => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get lastSyncAt => integer().nullable()();
}

/// Per-file local↔remote mapping — the heart of reconciliation. One row per
/// rel path within the synced folder.
class SyncState extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer()();
  TextColumn get relPath => text()();

  /// Hash of the on-disk (possibly encrypted) blob at last sync.
  TextColumn get localHash => text().nullable()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get remoteHash => text().nullable()();

  /// Common-ancestor hash for three-way reconciliation.
  TextColumn get baseHash => text().nullable()();
  TextColumn get state => text().withDefault(const Constant('synced'))();
  IntColumn get lastSyncedAt => integer().nullable()();
}

/// Append-only journal of catalog operations to replicate across devices via
/// the cloud oplog (M5c). Recorded now so mutations are captured from the start.
class ChangeLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()(); // document | folder | tag | ...
  TextColumn get entityUid => text()();
  TextColumn get op => text()(); // create | update | delete | move
  TextColumn get payloadJson => text().nullable()();
  IntColumn get createdAt => integer()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// A directory watched for new documents (e.g. Downloads). Configurable in
/// settings; scanned to produce [WatchSuggestions].
class WatchDirs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text().unique()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get recursive => boolean().withDefault(const Constant(false))();
  BoolColumn get autoImport => boolean().withDefault(const Constant(false))();
  TextColumn get defaultFolderUid => text().nullable()();

  /// Semicolon-separated `*.ext` globs; null = all recognized document types.
  TextColumn get globInclude => text().nullable()();
  TextColumn get globExclude => text().nullable()();
  IntColumn get createdAt => integer()();
}

/// A new file detected in a watched directory, pending the user's decision.
class WatchSuggestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get srcPath => text()();
  TextColumn get fileHash => text().nullable()();
  TextColumn get suggestedFolderUid => text().nullable()();
  TextColumn get suggestedCategoryUid => text().nullable()();

  /// pending | accepted | dismissed
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get detectedAt => integer()();
}

/// Extracted or OCR'd plaintext for a document, feeding full-text search.
/// Kept in the catalog DB (so it's covered by encryption in M6). The FTS5
/// virtual table `documents_fts` is maintained separately by the search
/// indexer from this table + the document title.
class DocumentText extends Table {
  TextColumn get documentUid => text()();

  /// plain | text_layer | office | ocr — where the text came from.
  TextColumn get source => text()();
  TextColumn get lang => text().nullable()();
  TextColumn get content => text().nullable()();
  IntColumn get charCount => integer().nullable()();
  IntColumn get extractedAt => integer()();
  TextColumn get engine => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {documentUid};
}

/// A smart folder is a saved query, not a physical folder. [queryJson] holds
/// the serialized filter DSL (fts text, tags, types, date range, category).
class SmartFolders extends Table with _SyncableColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get queryJson => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

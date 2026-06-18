import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../di/locator.dart';
import '../../services/library/library_service.dart';
import '../../services/ocr/ocr_engine.dart';
import '../../services/ocr/ocr_engine_factory.dart';
import '../../services/ocr/ocr_service.dart';
import '../../services/scanner/doc_scanner.dart';
import '../../services/scanner/doc_scanner_factory.dart';
import '../../services/search/search_indexer.dart';
import '../../services/security/app_key_manager.dart';
import '../../services/security/encrypted_secret_store.dart';
import '../../services/archive/archive_service.dart';
import '../../services/security/library_encryption.dart';
import '../../services/sync/google_oauth.dart';
import '../../services/sync/secret_store.dart';
import '../../services/update/update_service.dart';
import '../../services/watch/watch_service.dart';
import '../db/app_database.dart';
import 'category_repository.dart';
import 'document_repository.dart';
import 'folder_repository.dart';
import 'label_repository.dart';
import 'search_repository.dart';
import 'smart_folder_repository.dart';
import 'tag_repository.dart';
import 'watch_dir_repository.dart';
import 'watch_suggestion_repository.dart';

/// Riverpod wiring for the data layer. The database is a process singleton held
/// in get_it; repositories are thin and constructed per provider. UI reads
/// these providers; nothing in the UI touches the database directly.

final databaseProvider = Provider<AppDatabase>((ref) => getIt<AppDatabase>());

final libraryServiceProvider = Provider<LibraryService>(
  (ref) => LibraryService(ref.watch(databaseProvider)),
);

/// Singleton so the in-memory unlocked key persists across reads.
final libraryEncryptionProvider = Provider<LibraryEncryption>(
  (ref) => LibraryEncryption(ref.watch(databaseProvider)),
);

final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => DocumentRepository(
    ref.watch(databaseProvider),
    ref.watch(libraryServiceProvider),
    encryption: ref.watch(libraryEncryptionProvider),
  ),
);

final folderRepositoryProvider = Provider<FolderRepository>(
  (ref) => FolderRepository(ref.watch(databaseProvider)),
);

final tagRepositoryProvider = Provider<TagRepository>(
  (ref) => TagRepository(ref.watch(databaseProvider)),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(databaseProvider)),
);

final labelRepositoryProvider = Provider<LabelRepository>(
  (ref) => LabelRepository(ref.watch(databaseProvider)),
);

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.watch(databaseProvider)),
);

final smartFolderRepositoryProvider = Provider<SmartFolderRepository>(
  (ref) => SmartFolderRepository(ref.watch(databaseProvider)),
);

final ocrEngineProvider = Provider<OcrEngine>((ref) {
  final engine = createOcrEngine();
  ref.onDispose(engine.dispose);
  return engine;
});

final ocrServiceProvider = Provider<OcrService>(
  (ref) => OcrService(
    ref.watch(databaseProvider),
    ref.watch(libraryServiceProvider),
    ref.watch(ocrEngineProvider),
    SearchIndexer(ref.watch(databaseProvider)),
    encryption: ref.watch(libraryEncryptionProvider),
  ),
);

final docScannerProvider = Provider<DocScanner>((ref) => createDocScanner());

final archiveServiceProvider = Provider<ArchiveService>((ref) => ArchiveService());

final watchDirRepositoryProvider = Provider<WatchDirRepository>(
  (ref) => WatchDirRepository(ref.watch(databaseProvider)),
);

final watchServiceProvider = Provider<WatchService>(
  (ref) => WatchService(ref.watch(databaseProvider)),
);

final watchSuggestionRepositoryProvider = Provider<WatchSuggestionRepository>(
  (ref) => WatchSuggestionRepository(
    ref.watch(databaseProvider),
    ref.watch(documentRepositoryProvider),
  ),
);

final watchDirsProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(watchDirRepositoryProvider).watchAll(),
);

final pendingSuggestionsProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(watchSuggestionRepositoryProvider).watchPending(),
);

final appKeyManagerProvider =
    Provider<AppKeyManager>((ref) => FileAppKeyManager());

final secretStoreProvider = Provider<SecretStore>(
  (ref) => EncryptedSecretStore(
    ref.watch(databaseProvider),
    ref.watch(appKeyManagerProvider),
  ),
);

final updateServiceProvider = Provider<UpdateService>((ref) => UpdateService());

/// The running app's package metadata (version + build number), for display.
final packageInfoProvider =
    FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

final googleOAuthProvider = Provider<GoogleOAuth>((ref) => GoogleOAuth());

final smartFoldersProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(smartFolderRepositoryProvider).watchAll(),
);

/// Folders at the top level of the tree.
final rootFoldersProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(folderRepositoryProvider).watchChildren(null),
);

/// Documents inside a given folder uid (null = unfiled).
final documentsInFolderProvider =
    StreamProvider.autoDispose.family<List<Document>, String?>(
  (ref, folderUid) =>
      ref.watch(documentRepositoryProvider).watchInFolder(folderUid),
);

/// Everything currently in the Trash.
final trashProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(documentRepositoryProvider).watchTrash(),
);

/// Groups of exact-duplicate documents (same content hash).
final duplicateGroupsProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(documentRepositoryProvider).watchDuplicates(),
);

/// Live view of a single document (for the detail panel).
final documentByUidProvider =
    StreamProvider.autoDispose.family<Document?, String>(
  (ref, uid) => ref.watch(documentRepositoryProvider).watchByUid(uid),
);

final allTagsProvider = StreamProvider.autoDispose<List<Tag>>(
  (ref) => ref.watch(tagRepositoryProvider).watchAll(),
);

final tagsForDocumentProvider =
    StreamProvider.autoDispose.family<List<Tag>, String>(
  (ref, docUid) =>
      ref.watch(tagRepositoryProvider).watchTagsForDocument(docUid),
);

final allLabelsProvider = StreamProvider.autoDispose<List<Label>>(
  (ref) => ref.watch(labelRepositoryProvider).watchAll(),
);

final labelsForDocumentProvider =
    StreamProvider.autoDispose.family<List<Label>, String>(
  (ref, docUid) =>
      ref.watch(labelRepositoryProvider).watchLabelsForDocument(docUid),
);

final allCategoriesProvider = StreamProvider.autoDispose<List<Category>>(
  (ref) => ref.watch(categoryRepositoryProvider).watchAll(),
);

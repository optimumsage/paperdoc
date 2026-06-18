import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/providers.dart';
import '../../services/sync/google_drive_provider.dart';
import '../../services/sync/sync_engine.dart';
import '../security/library_lock_controller.dart';

/// UI state for the Google Drive connection.
class SyncUiState {
  const SyncUiState({
    this.hasCredentials = false,
    this.connected = false,
    this.accountLabel,
    this.lastSyncAt,
    this.busy = false,
    this.error,
    this.lastReport,
    this.needsPassword = false,
  });

  final bool hasCredentials;
  final bool connected;
  final String? accountLabel;
  final int? lastSyncAt;
  final bool busy;
  final String? error;
  final String? lastReport;

  /// The cloud library is encrypted but this device has no key yet — prompt for
  /// the master password to onboard.
  final bool needsPassword;

  SyncUiState copyWith({
    bool? hasCredentials,
    bool? connected,
    String? accountLabel,
    int? lastSyncAt,
    bool? busy,
    Object? error = _keep,
    Object? lastReport = _keep,
    bool? needsPassword,
  }) {
    return SyncUiState(
      hasCredentials: hasCredentials ?? this.hasCredentials,
      connected: connected ?? this.connected,
      accountLabel: accountLabel ?? this.accountLabel,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      busy: busy ?? this.busy,
      error: error == _keep ? this.error : error as String?,
      lastReport: lastReport == _keep ? this.lastReport : lastReport as String?,
      needsPassword: needsPassword ?? this.needsPassword,
    );
  }

  static const _keep = Object();
}

const _kClientId = 'gdrive.clientId';
const _kClientSecret = 'gdrive.clientSecret';
const _kRefreshToken = 'gdrive.refreshToken';

class SyncController extends Notifier<SyncUiState> {
  Map<String, dynamic>? _pendingManifest;

  @override
  SyncUiState build() {
    Future.microtask(_load);
    return const SyncUiState();
  }

  Future<SyncAccount?> _account() async {
    final db = ref.read(databaseProvider);
    return (db.select(db.syncAccounts)
          ..where((t) => t.provider.equals('gdrive')))
        .getSingleOrNull();
  }

  Future<void> _load() async {
    final secrets = ref.read(secretStoreProvider);
    final clientId = await secrets.read(_kClientId);
    final clientSecret = await secrets.read(_kClientSecret);
    final refreshToken = await secrets.read(_kRefreshToken);
    final account = await _account();
    state = state.copyWith(
      hasCredentials: clientId != null && clientSecret != null,
      connected: refreshToken != null && account != null,
      accountLabel: account?.displayName,
      lastSyncAt: account?.lastSyncAt,
    );
  }

  Future<void> saveCredentials(String clientId, String clientSecret) async {
    final secrets = ref.read(secretStoreProvider);
    await secrets.write(_kClientId, clientId.trim());
    await secrets.write(_kClientSecret, clientSecret.trim());
    await _load();
  }

  Future<void> connect() async {
    final secrets = ref.read(secretStoreProvider);
    final clientId = await secrets.read(_kClientId);
    final clientSecret = await secrets.read(_kClientSecret);
    if (clientId == null || clientSecret == null) {
      state = state.copyWith(error: 'Enter your client ID and secret first.');
      return;
    }
    state = state.copyWith(busy: true, error: null);
    try {
      final tokens = await ref
          .read(googleOAuthProvider)
          .signIn(clientId: clientId, clientSecret: clientSecret);
      if (tokens.refreshToken == null) {
        throw Exception(
            'Google did not return a refresh token. Revoke prior access for '
            'this app in your Google account and try again.');
      }
      await secrets.write(_kRefreshToken, tokens.refreshToken!);

      final db = ref.read(databaseProvider);
      if (await _account() == null) {
        await db.into(db.syncAccounts).insert(
              SyncAccountsCompanion.insert(
                provider: 'gdrive',
                accountId: 'me',
                displayName: const Value('Google Drive'),
              ),
            );
      }
      await _load();
    } catch (e) {
      state = state.copyWith(error: '$e');
    } finally {
      state = state.copyWith(busy: false);
    }
  }

  /// Builds a Drive-backed sync engine from stored credentials, or sets an
  /// error and returns null when Drive isn't connected.
  Future<({SyncEngine engine, SyncAccount account, GoogleDriveProvider provider})?>
      _buildEngine() async {
    final account = await _account();
    final secrets = ref.read(secretStoreProvider);
    final clientId = await secrets.read(_kClientId);
    final clientSecret = await secrets.read(_kClientSecret);
    final refreshToken = await secrets.read(_kRefreshToken);
    if (account == null ||
        clientId == null ||
        clientSecret == null ||
        refreshToken == null) {
      state = state.copyWith(error: 'Connect Google Drive first.');
      return null;
    }
    final session = GoogleAuthSession(
      clientId: clientId,
      clientSecret: clientSecret,
      refreshToken: refreshToken,
    );
    final provider = GoogleDriveProvider(session, rootId: account.rootRemoteId);
    final engine = SyncEngine(
      ref.read(databaseProvider),
      ref.read(libraryServiceProvider),
      provider,
      encryption: ref.read(libraryEncryptionProvider),
    );
    return (engine: engine, account: account, provider: provider);
  }

  /// Ensures [doc]'s blob is on disk, downloading it on demand when the
  /// document is a cloud-only placeholder. Returns true when it's local after.
  Future<bool> ensureLocal(Document doc) async {
    if (doc.downloadState == 'local') return true;
    final built = await _buildEngine();
    if (built == null) return false;
    final docs = ref.read(documentRepositoryProvider);
    await docs.setDownloadState(doc.uid, 'downloading');
    try {
      await built.engine.downloadBlob(built.account.id, doc);
      return true;
    } catch (e) {
      await docs.setDownloadState(doc.uid, 'cloud');
      state = state.copyWith(error: 'Download failed: $e');
      return false;
    }
  }

  Future<void> syncNow() async {
    final built = await _buildEngine();
    if (built == null) return;
    final account = built.account;
    final provider = built.provider;
    final engine = built.engine;
    state = state.copyWith(busy: true, error: null);
    try {
      // Onboarding: if the cloud library is encrypted but this device has no
      // key, prompt for the master password before syncing (otherwise the
      // downloaded blobs would be undecryptable ciphertext).
      if (!await ref.read(libraryEncryptionProvider).isEncrypted()) {
        final manifest = await engine.fetchRemoteManifest();
        if (manifest != null) {
          _pendingManifest = manifest;
          state = state.copyWith(busy: false, needsPassword: true);
          return;
        }
      }

      final report = await engine.sync(account.id);

      if (account.rootRemoteId == null && provider.rootId != null) {
        final db = ref.read(databaseProvider);
        await (db.update(db.syncAccounts)
              ..where((t) => t.id.equals(account.id)))
            .write(SyncAccountsCompanion(rootRemoteId: Value(provider.rootId)));
      }
      await _load();
      state = state.copyWith(lastReport: report.toString());
    } catch (e) {
      state = state.copyWith(error: '$e');
    } finally {
      state = state.copyWith(busy: false);
    }
  }

  /// Adopts the cloud library's encryption with [password] (after the prompt),
  /// then proceeds to sync.
  Future<void> submitOnboardingPassword(String password) async {
    final manifest = _pendingManifest;
    if (manifest == null) return;
    state = state.copyWith(busy: true, error: null);
    final ok = await ref
        .read(libraryEncryptionProvider)
        .adoptRemote(password, manifest);
    if (!ok) {
      state = state.copyWith(busy: false, error: 'Incorrect master password.');
      return;
    }
    _pendingManifest = null;
    ref.invalidate(libraryLockProvider); // library is now encrypted + unlocked
    state = state.copyWith(busy: false, needsPassword: false);
    await syncNow();
  }

  void cancelOnboarding() {
    _pendingManifest = null;
    state = state.copyWith(needsPassword: false);
  }

  Future<void> disconnect() async {
    final db = ref.read(databaseProvider);
    final account = await _account();
    if (account != null) {
      await (db.delete(db.syncState)
            ..where((t) => t.accountId.equals(account.id)))
          .go();
      await (db.delete(db.syncAccounts)..where((t) => t.id.equals(account.id)))
          .go();
    }
    await ref.read(secretStoreProvider).delete(_kRefreshToken);
    await _load();
  }
}

final syncControllerProvider =
    NotifierProvider<SyncController, SyncUiState>(SyncController.new);

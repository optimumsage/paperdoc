import '../../data/db/app_database.dart';

/// Stores sensitive values (OAuth client secret, refresh tokens). The app uses
/// only this interface so M6 can swap in an app-level encrypted vault without
/// touching callers.
abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// TEMPORARY (M5): keeps secrets in the settings table, unencrypted. M6
/// replaces this with an app-level encrypted vault — per the user's
/// requirement, NOT the OS keychain. Tracked as a follow-up.
class SettingsSecretStore implements SecretStore {
  SettingsSecretStore(this._db);

  final AppDatabase _db;
  static const _prefix = 'secret.';

  @override
  Future<String?> read(String key) => _db.getSetting('$_prefix$key');

  @override
  Future<void> write(String key, String value) =>
      _db.setSetting('$_prefix$key', value);

  @override
  Future<void> delete(String key) => _db.setSetting('$_prefix$key', null);
}

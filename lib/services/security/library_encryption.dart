import 'dart:convert';
import 'dart:typed_data';

import '../../data/db/app_database.dart';
import 'crypto_service.dart';

/// Manages a library's optional encryption: enabling it (deriving a key from a
/// master password), unlocking it on later sessions, and encrypting/decrypting
/// blob bytes. The derived key lives only in memory while unlocked.
///
/// Encryption config is stored in the settings table:
///   library.encrypted = 'true'
///   library.kdf       = JSON(KdfParams)  (non-secret; salt + params)
///   library.verifier  = encrypted known token, to validate the password
class LibraryEncryption {
  LibraryEncryption(this._db, {CryptoService? crypto})
      : _crypto = crypto ?? CryptoService();

  final AppDatabase _db;
  final CryptoService _crypto;
  List<int>? _key;

  static const _kEncrypted = 'library.encrypted';
  static const _kKdf = 'library.kdf';
  static const _kVerifier = 'library.verifier';
  static const _token = 'paperdoc-verify-v1';

  bool get isUnlocked => _key != null;

  Future<bool> isEncrypted() async =>
      (await _db.getSetting(_kEncrypted)) == 'true';

  /// True only when the library is encrypted AND currently unlocked — the
  /// condition under which new blobs should be written as ciphertext.
  Future<bool> shouldEncrypt() async => isUnlocked && await isEncrypted();

  /// Turns on encryption for a fresh library using [password]. [params] is
  /// overridable for tests; production uses strong Argon2id defaults.
  Future<void> enable(String password, {KdfParams? params}) async {
    params ??= KdfParams.generate();
    final key = await _crypto.deriveLibraryKey(password, params);
    final verifier = await _crypto.encryptFile(utf8.encode(_token), key);
    await _db.setSetting(_kEncrypted, 'true');
    await _db.setSetting(_kKdf, jsonEncode(params.toMap()));
    await _db.setSetting(_kVerifier, base64Encode(verifier));
    _key = key;
  }

  /// Attempts to unlock with [password]; returns true on success.
  Future<bool> unlock(String password) async {
    final kdfJson = await _db.getSetting(_kKdf);
    final verifierB64 = await _db.getSetting(_kVerifier);
    if (kdfJson == null || verifierB64 == null) return false;
    final params =
        KdfParams.fromMap(jsonDecode(kdfJson) as Map<String, dynamic>);
    final key = await _crypto.deriveLibraryKey(password, params);
    try {
      final decrypted = await _crypto.decryptFile(base64Decode(verifierB64), key);
      if (utf8.decode(decrypted) != _token) return false;
      _key = key;
      return true;
    } catch (_) {
      return false;
    }
  }

  void lock() => _key = null;

  /// Non-secret manifest (KDF params + verifier) uploaded to the cloud so a
  /// second device can derive the same key from just the master password.
  Future<String?> manifestJson() async {
    final kdf = await _db.getSetting(_kKdf);
    final verifier = await _db.getSetting(_kVerifier);
    if (kdf == null || verifier == null) return null;
    return jsonEncode({
      'encrypted': true,
      'kdf': jsonDecode(kdf),
      'verifier': verifier,
    });
  }

  /// Onboards this device to an existing encrypted library described by a remote
  /// [manifest]: verifies [password], stores the config locally, and unlocks.
  Future<bool> adoptRemote(String password, Map<String, dynamic> manifest) async {
    final kdfMap = (manifest['kdf'] as Map).cast<String, dynamic>();
    final verifierB64 = manifest['verifier'] as String;
    final params = KdfParams.fromMap(kdfMap);
    final key = await _crypto.deriveLibraryKey(password, params);
    try {
      final decrypted = await _crypto.decryptFile(base64Decode(verifierB64), key);
      if (utf8.decode(decrypted) != _token) return false;
    } catch (_) {
      return false;
    }
    await _db.setSetting(_kEncrypted, 'true');
    await _db.setSetting(_kKdf, jsonEncode(kdfMap));
    await _db.setSetting(_kVerifier, verifierB64);
    _key = key;
    return true;
  }

  Future<Uint8List> encrypt(List<int> plaintext) {
    final key = _key;
    if (key == null) throw StateError('Library is locked');
    return _crypto.encryptFile(plaintext, key);
  }

  Future<Uint8List> decrypt(List<int> blob) {
    final key = _key;
    if (key == null) throw StateError('Library is locked');
    return _crypto.decryptFile(blob, key);
  }
}

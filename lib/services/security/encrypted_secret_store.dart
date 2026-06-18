import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../../data/db/app_database.dart';
import '../sync/secret_store.dart';
import 'app_key_manager.dart';

/// [SecretStore] that encrypts values with the app-level key (AES-GCM-256) and
/// stores the ciphertext in the settings table. This replaces the plaintext
/// store from M5 so OAuth tokens and other secrets are encrypted at rest.
class EncryptedSecretStore implements SecretStore {
  EncryptedSecretStore(this._db, this._keys);

  final AppDatabase _db;
  final AppKeyManager _keys;
  final AesGcm _algorithm = AesGcm.with256bits();

  static const _prefix = 'enc.';
  static const _nonceLen = 12;
  static const _macLen = 16;

  Future<SecretKey> _key() async => SecretKey(await _keys.rawKey());

  @override
  Future<void> write(String key, String value) async {
    final box = await _algorithm.encrypt(
      utf8.encode(value),
      secretKey: await _key(),
    );
    final blob = base64Encode([...box.nonce, ...box.mac.bytes, ...box.cipherText]);
    await _db.setSetting('$_prefix$key', blob);
  }

  @override
  Future<String?> read(String key) async {
    final blob = await _db.getSetting('$_prefix$key');
    if (blob == null) return null;
    final bytes = base64Decode(blob);
    if (bytes.length < _nonceLen + _macLen) return null;
    final nonce = bytes.sublist(0, _nonceLen);
    final mac = bytes.sublist(_nonceLen, _nonceLen + _macLen);
    final cipher = bytes.sublist(_nonceLen + _macLen);
    try {
      final clear = await _algorithm.decrypt(
        SecretBox(cipher, nonce: nonce, mac: Mac(mac)),
        secretKey: await _key(),
      );
      return utf8.decode(clear);
    } on SecretBoxAuthenticationError {
      return null; // wrong key or tampered ciphertext
    }
  }

  @override
  Future<void> delete(String key) => _db.setSetting('$_prefix$key', null);
}

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Argon2id parameters + salt for deriving a library key from a master
/// password. These travel (non-secret) in the cloud manifest so a second device
/// can derive the same key from just the password.
class KdfParams {
  const KdfParams({
    required this.salt,
    this.memory = 19456, // ~19 MiB
    this.iterations = 2,
    this.parallelism = 1,
    this.hashLength = 32,
  });

  final List<int> salt;
  final int memory;
  final int iterations;
  final int parallelism;
  final int hashLength;

  Map<String, dynamic> toMap() => {
        'salt': base64Encode(salt),
        'memory': memory,
        'iterations': iterations,
        'parallelism': parallelism,
        'hashLength': hashLength,
      };

  factory KdfParams.fromMap(Map<String, dynamic> m) => KdfParams(
        salt: base64Decode(m['salt'] as String),
        memory: m['memory'] as int,
        iterations: m['iterations'] as int,
        parallelism: m['parallelism'] as int,
        hashLength: m['hashLength'] as int,
      );

  factory KdfParams.generate() =>
      KdfParams(salt: CryptoService.randomBytes(16));
}

/// Cryptographic primitives for per-library encryption:
///   * master password → library key via Argon2id,
///   * per-file content key (random) encrypted with XChaCha20-Poly1305 and
///     wrapped by the library key.
///
/// The encrypted blob is self-describing so it can be decrypted with only the
/// library key:
///   magic(4) | version(1) | wrap[nonce|mac|cipher(32)] | content[nonce|mac|cipher]
class CryptoService {
  CryptoService();

  final Xchacha20 _cipher = Xchacha20.poly1305Aead();
  static const _magic = [0x50, 0x44, 0x45, 0x4E]; // 'PDEN'
  static const _version = 1;
  static const _macLen = 16;

  int get _nonceLen => _cipher.nonceLength;

  /// Derives the 32-byte library key from [password] using [params].
  Future<List<int>> deriveLibraryKey(String password, KdfParams params) async {
    final argon2id = Argon2id(
      parallelism: params.parallelism,
      memory: params.memory,
      iterations: params.iterations,
      hashLength: params.hashLength,
    );
    final key = await argon2id.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: params.salt,
    );
    return key.extractBytes();
  }

  Future<Uint8List> encryptFile(
      List<int> plaintext, List<int> libraryKey) async {
    final fileKey = randomBytes(32);
    final wrap =
        await _cipher.encrypt(fileKey, secretKey: SecretKey(libraryKey));
    final content =
        await _cipher.encrypt(plaintext, secretKey: SecretKey(fileKey));

    final builder = BytesBuilder();
    builder.add(_magic);
    builder.addByte(_version);
    builder.add(_serialize(wrap));
    builder.add(_serialize(content));
    return builder.toBytes();
  }

  Future<Uint8List> decryptFile(List<int> blob, List<int> libraryKey) async {
    final data = blob is Uint8List ? blob : Uint8List.fromList(blob);
    if (data.length < 5 || !_listEq(data.sublist(0, 4), _magic)) {
      throw const FormatException('Not a PaperDoc encrypted blob');
    }
    var offset = 5;

    // Wrapped file key: cipher length == 32 (the key size).
    final wrapBox = _deserialize(data, offset, 32);
    offset += _nonceLen + _macLen + 32;
    final fileKey =
        await _cipher.decrypt(wrapBox, secretKey: SecretKey(libraryKey));

    final contentLen = data.length - offset - _nonceLen - _macLen;
    final contentBox = _deserialize(data, offset, contentLen);
    final plaintext =
        await _cipher.decrypt(contentBox, secretKey: SecretKey(fileKey));
    return Uint8List.fromList(plaintext);
  }

  List<int> _serialize(SecretBox box) =>
      [...box.nonce, ...box.mac.bytes, ...box.cipherText];

  SecretBox _deserialize(Uint8List data, int offset, int cipherLen) {
    final nonce = data.sublist(offset, offset + _nonceLen);
    final mac =
        data.sublist(offset + _nonceLen, offset + _nonceLen + _macLen);
    final cipher = data.sublist(
        offset + _nonceLen + _macLen, offset + _nonceLen + _macLen + cipherLen);
    return SecretBox(cipher, nonce: nonce, mac: Mac(mac));
  }

  static List<int> randomBytes(int n) {
    final rng = Random.secure();
    return List<int>.generate(n, (_) => rng.nextInt(256));
  }

  static bool _listEq(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

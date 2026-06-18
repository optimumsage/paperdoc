import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/services/security/crypto_service.dart';

void main() {
  // Small Argon2id params keep the test fast; production uses stronger ones.
  KdfParams fastParams() => const KdfParams(
        salt: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
        memory: 256,
        iterations: 1,
        parallelism: 1,
        hashLength: 32,
      );

  test('key derivation is deterministic and password-sensitive', () async {
    final svc = CryptoService();
    final params = fastParams();

    final a = await svc.deriveLibraryKey('correct horse', params);
    final b = await svc.deriveLibraryKey('correct horse', params);
    final c = await svc.deriveLibraryKey('wrong horse', params);

    expect(a, b);
    expect(a, isNot(c));
    expect(a.length, 32);
  });

  test('encrypt then decrypt round-trips with the library key', () async {
    final svc = CryptoService();
    final key = List<int>.generate(32, (i) => i);
    final plaintext = utf8.encode('top secret document contents');

    final blob = await svc.encryptFile(plaintext, key);
    expect(blob, isNot(plaintext));

    final restored = await svc.decryptFile(blob, key);
    expect(restored, plaintext);
  });

  test('wrong library key cannot decrypt', () async {
    final svc = CryptoService();
    final key = List<int>.generate(32, (i) => i);
    final blob = await svc.encryptFile(utf8.encode('secret'), key);

    final wrong = List<int>.filled(32, 9);
    expect(() => svc.decryptFile(blob, wrong), throwsA(anything));
  });

  test('KdfParams serialize round-trips', () {
    final params = KdfParams.generate();
    final back = KdfParams.fromMap(params.toMap());
    expect(back.salt, params.salt);
    expect(back.memory, params.memory);
    expect(back.iterations, params.iterations);
  });
}

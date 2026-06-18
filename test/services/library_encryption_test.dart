import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/data/repositories/document_repository.dart';
import 'package:paperdoc/services/library/library_service.dart';
import 'package:paperdoc/services/security/crypto_service.dart';
import 'package:paperdoc/services/security/library_encryption.dart';
import 'package:path/path.dart' as p;

const _fastParams = KdfParams(
  salt: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
  memory: 256,
  iterations: 1,
  parallelism: 1,
  hashLength: 32,
);

void main() {
  group('LibraryEncryption', () {
    late AppDatabase db;
    late LibraryEncryption enc;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      enc = LibraryEncryption(db, crypto: CryptoService());
    });
    tearDown(() => db.close());

    test('enable then unlock with correct/incorrect password', () async {
      expect(await enc.isEncrypted(), isFalse);
      await enc.enable('master-pass', params: _fastParams);
      expect(await enc.isEncrypted(), isTrue);
      expect(enc.isUnlocked, isTrue);

      // Simulate a fresh session (locked).
      enc.lock();
      expect(enc.isUnlocked, isFalse);

      expect(await enc.unlock('wrong'), isFalse);
      expect(enc.isUnlocked, isFalse);
      expect(await enc.unlock('master-pass'), isTrue);
      expect(enc.isUnlocked, isTrue);
    });
  });

  test('imports into an encrypted library are stored as ciphertext', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final tmp = await Directory.systemTemp.createTemp('paperdoc_enc_');
    addTearDown(() => tmp.delete(recursive: true));

    final library = LibraryService(db);
    await library.setRoot(p.join(tmp.path, 'library'));
    final encryption = LibraryEncryption(db);
    await encryption.enable('pw123456', params: _fastParams);

    final repo = DocumentRepository(db, library, encryption: encryption);

    const content = 'confidential contents';
    final src = File(p.join(tmp.path, 'secret.txt'));
    await src.writeAsString(content);

    final doc = await repo.importFile(src.path);

    expect(doc.isEncrypted, isTrue);
    expect(doc.contentHash, sha256.convert(utf8.encode(content)).toString());
    expect(doc.encHash, isNotNull);

    // On-disk blob is ciphertext (PaperDoc magic header 'PDEN'), not plaintext.
    final onDisk = await library.blobFile(doc.relPath).readAsBytes();
    expect(onDisk.sublist(0, 4), [0x50, 0x44, 0x45, 0x4E]);
    expect(utf8.decode(onDisk, allowMalformed: true).contains(content), isFalse);

    // Decrypts back to the original.
    final restored = await encryption.decrypt(onDisk);
    expect(utf8.decode(restored), content);
  });
}

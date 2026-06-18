import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/services/security/app_key_manager.dart';
import 'package:paperdoc/services/security/encrypted_secret_store.dart';

void main() {
  test('round-trips secrets and stores only ciphertext', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final store = EncryptedSecretStore(
        db, StaticAppKeyManager(List<int>.generate(32, (i) => i)));

    expect(await store.read('token'), isNull);
    await store.write('token', 'super-secret-token');
    expect(await store.read('token'), 'super-secret-token');

    final atRest = await db.getSetting('enc.token');
    expect(atRest, isNotNull);
    expect(atRest!.contains('super-secret'), isFalse);

    await store.delete('token');
    expect(await store.read('token'), isNull);
  });

  test('a different app key cannot decrypt', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final writer =
        EncryptedSecretStore(db, StaticAppKeyManager(List.filled(32, 1)));
    await writer.write('token', 'value');

    final wrongKey =
        EncryptedSecretStore(db, StaticAppKeyManager(List.filled(32, 2)));
    expect(await wrongKey.read('token'), isNull);
  });
}

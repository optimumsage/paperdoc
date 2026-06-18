import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/data/db/app_database.dart';
import 'package:paperdoc/services/sync/google_oauth.dart';
import 'package:paperdoc/services/sync/secret_store.dart';

void main() {
  test('PKCE challenge matches the RFC 7636 reference vector', () {
    // From RFC 7636 Appendix B.
    const verifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
    const expected = 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM';
    expect(GoogleOAuth.pkceChallenge(verifier), expected);
  });

  test('secret store round-trips and deletes via the settings table', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final store = SettingsSecretStore(db);

    expect(await store.read('token'), isNull);
    await store.write('token', 'abc123');
    expect(await store.read('token'), 'abc123');
    await store.delete('token');
    expect(await store.read('token'), isNull);
  });
}

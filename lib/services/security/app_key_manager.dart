import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Supplies the app-level key used to encrypt secrets at rest. Per the user's
/// explicit choice, this is an app-managed key (NOT the OS keychain) — weaker
/// than a hardware-backed keystore, but fully under the app's control.
abstract interface class AppKeyManager {
  Future<List<int>> rawKey();
}

/// Generates a random 32-byte key on first use and persists it in the
/// app-support directory.
class FileAppKeyManager implements AppKeyManager {
  FileAppKeyManager({this.fileName = 'app.key'});

  final String fileName;
  List<int>? _cached;

  @override
  Future<List<int>> rawKey() async {
    if (_cached != null) return _cached!;
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'paperdoc', fileName));
    if (await file.exists()) {
      return _cached = base64Decode((await file.readAsString()).trim());
    }
    final rng = Random.secure();
    final key = List<int>.generate(32, (_) => rng.nextInt(256));
    await file.parent.create(recursive: true);
    await file.writeAsString(base64Encode(key));
    return _cached = key;
  }
}

/// Injectable fixed key, for tests.
class StaticAppKeyManager implements AppKeyManager {
  StaticAppKeyManager(this.key);
  final List<int> key;

  @override
  Future<List<int>> rawKey() async => key;
}

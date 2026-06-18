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
import 'package:paperdoc/services/sync/cloud_provider.dart';
import 'package:paperdoc/services/sync/sync_engine.dart';
import 'package:path/path.dart' as p;

class FakeCloud implements CloudProvider {
  final Map<String, ({String id, List<int> bytes, String hash})> files = {};

  @override
  String get name => 'fake';
  @override
  Future<String> ensureRoot() async => 'root';
  @override
  Future<List<RemoteFile>> listFiles() async => [
        for (final e in files.entries)
          RemoteFile(
              id: e.value.id,
              relPath: e.key,
              hash: e.value.hash,
              size: e.value.bytes.length),
      ];
  @override
  Future<void> download(RemoteFile file, String localPath) async {
    final out = File(localPath);
    await out.parent.create(recursive: true);
    await out.writeAsBytes(files[file.relPath]!.bytes);
  }

  @override
  Future<RemoteFile> upload({
    required String localPath,
    required String relPath,
    String? existingId,
  }) async {
    final bytes = await File(localPath).readAsBytes();
    final hash = sha256.convert(bytes).toString();
    files[relPath] = (id: relPath, bytes: bytes, hash: hash);
    return RemoteFile(
        id: relPath, relPath: relPath, hash: hash, size: bytes.length);
  }

  @override
  Future<void> delete(String id) async =>
      files.removeWhere((key, value) => value.id == id);
}

const _fast = KdfParams(
  salt: [9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5, 6],
  memory: 256,
  iterations: 1,
  parallelism: 1,
  hashLength: 32,
);

void main() {
  test('encrypted library syncs ciphertext; second device onboards & decrypts',
      () async {
    final cloud = FakeCloud();
    final tmp = await Directory.systemTemp.createTemp('paperdoc_encsync_');
    addTearDown(() => tmp.delete(recursive: true));

    // ---- Device A: enable encryption, import, sync up ----
    final dbA = AppDatabase(NativeDatabase.memory());
    addTearDown(dbA.close);
    final libA = LibraryService(dbA);
    await libA.setRoot(p.join(tmp.path, 'A'));
    final encA = LibraryEncryption(dbA);
    await encA.enable('master-pw', params: _fast);
    final repoA = DocumentRepository(dbA, libA, encryption: encA);
    final engineA = SyncEngine(dbA, libA, cloud, encryption: encA);
    final accA = await dbA
        .into(dbA.syncAccounts)
        .insert(SyncAccountsCompanion.insert(provider: 'fake', accountId: 'me'));

    final src = File(p.join(tmp.path, 'secret.txt'));
    await src.writeAsString('classified content');
    final docA = await repoA.importFile(src.path);
    expect(docA.isEncrypted, isTrue);

    await engineA.sync(accA);

    // The cloud blob must be ciphertext (PaperDoc 'PDEN' header), not plaintext.
    final remoteBlob = cloud.files[docA.relPath]!.bytes;
    expect(remoteBlob.sublist(0, 4), [0x50, 0x44, 0x45, 0x4E]);
    expect(utf8.decode(remoteBlob, allowMalformed: true).contains('classified'),
        isFalse);

    // ---- Device B: onboard from the manifest, sync down, decrypt ----
    final dbB = AppDatabase(NativeDatabase.memory());
    addTearDown(dbB.close);
    final libB = LibraryService(dbB);
    await libB.setRoot(p.join(tmp.path, 'B'));
    final encB = LibraryEncryption(dbB);
    final engineB = SyncEngine(dbB, libB, cloud, encryption: encB);
    final accB = await dbB
        .into(dbB.syncAccounts)
        .insert(SyncAccountsCompanion.insert(provider: 'fake', accountId: 'me'));

    final manifest = await engineB.fetchRemoteManifest();
    expect(manifest, isNotNull);
    expect(await encB.adoptRemote('wrong-pw', manifest!), isFalse);
    expect(await encB.adoptRemote('master-pw', manifest), isTrue);

    final report = await engineB.sync(accB);
    expect(report.downloaded, 1);

    final docB = await (dbB.select(dbB.documents)
          ..where((t) => t.uid.equals(docA.uid)))
        .getSingle();
    expect(docB.isEncrypted, isTrue);
    // On-demand: arrives as a cloud placeholder; fetch the ciphertext blob.
    expect(docB.downloadState, 'cloud');
    await engineB.downloadBlob(accB, docB);

    final cipher = await libB.blobFile(docB.relPath).readAsBytes();
    final plain = await encB.decrypt(cipher);
    expect(utf8.decode(plain), 'classified content');
  });
}

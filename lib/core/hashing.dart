import 'dart:io';

import 'package:crypto/crypto.dart';

/// Streams the file through SHA-256 so we never load a large document fully
/// into memory. The hex digest is the document's stable content identity,
/// used for dedup and (in M5) sync reconciliation.
Future<String> sha256OfFile(File file) async {
  final digest = await sha256.bind(file.openRead()).first;
  return digest.toString();
}

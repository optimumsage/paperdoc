import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/services/scanner/doc_scanner.dart';

void main() {
  test('unsupported scanner reports unsupported and yields nothing', () async {
    const scanner = UnsupportedDocScanner();
    expect(scanner.isSupported, isFalse);
    expect(await scanner.scan(), isEmpty);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/services/update/update_service.dart';

void main() {
  test('version comparison handles v-prefix, build suffix, and padding', () {
    expect(isNewerVersion('v0.2.0', '0.1.0'), isTrue);
    expect(isNewerVersion('v0.1.1', '0.1.0'), isTrue);
    expect(isNewerVersion('v1.0.0', '0.9.9'), isTrue);
    expect(isNewerVersion('v0.1', '0.1.0'), isFalse); // 0.1 == 0.1.0
    expect(isNewerVersion('v0.1.0', '0.1.0+5'), isFalse);
    expect(isNewerVersion('v0.1.0', '0.2.0'), isFalse);
    expect(isNewerVersion('0.1.0', '0.1.0'), isFalse);
  });
}

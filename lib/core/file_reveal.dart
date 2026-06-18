import 'dart:io';

import 'package:path/path.dart' as p;

/// Reveals a file in the OS file manager (Finder / Explorer / file browser),
/// selecting it where supported. Desktop only.
Future<void> revealInFileManager(String path) async {
  if (Platform.isMacOS) {
    await Process.run('open', ['-R', path]);
  } else if (Platform.isWindows) {
    await Process.run('explorer', ['/select,', path]);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', [p.dirname(path)]);
  }
}

import 'package:flutter/foundation.dart';

/// Central place to ask "what platform am I on" so feature code never imports
/// `dart:io` Platform directly. The native-capability seams in `lib/platform/`
/// use this to pick implementations (e.g. ML Kit on Android vs Tesseract on
/// desktop), and the UI uses it to decide layout (nav rail vs nav bar).
class PlatformInfo {
  const PlatformInfo._();

  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

  /// Desktop = the targets PaperDoc ships on besides Android.
  static bool get isDesktop => isMacOS || isWindows;
  static bool get isMobile => isAndroid;
}

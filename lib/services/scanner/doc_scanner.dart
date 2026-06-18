/// Platform-agnostic document scanner contract. Android uses ML Kit's
/// auto-crop/enhance scanner; other platforms report unsupported.
abstract interface class DocScanner {
  bool get isSupported;

  /// Launches the scanner UI and returns the file paths it produced (a single
  /// PDF, typically), or an empty list if the user cancelled.
  Future<List<String>> scan();
}

/// Fallback for platforms without a built-in scanner (desktop).
class UnsupportedDocScanner implements DocScanner {
  const UnsupportedDocScanner();

  @override
  bool get isSupported => false;

  @override
  Future<List<String>> scan() async => const [];
}

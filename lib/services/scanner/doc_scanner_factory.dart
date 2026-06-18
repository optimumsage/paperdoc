import '../../core/platform_info.dart';
import 'doc_scanner.dart';
import 'mlkit_doc_scanner.dart';

/// ML Kit scanner on Android; unsupported elsewhere.
DocScanner createDocScanner() =>
    PlatformInfo.isAndroid ? MlKitDocScanner() : const UnsupportedDocScanner();

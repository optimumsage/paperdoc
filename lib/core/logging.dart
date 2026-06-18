import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Configures the root logger. Call once during app bootstrap.
///
/// In debug mode everything is printed; in release we keep INFO and above.
void setupLogging() {
  Logger.root.level = kReleaseMode ? Level.INFO : Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}

/// Convenience factory so feature code reads `log = appLogger('Sync')`.
Logger appLogger(String name) => Logger(name);

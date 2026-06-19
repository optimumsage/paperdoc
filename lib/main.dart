import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/logging.dart';
import 'di/locator.dart';
import 'services/tray/tray_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  await configureDependencies();
  // On Windows/macOS, run in the background with a tray icon when closed.
  await TrayService.instance.init();
  runApp(const ProviderScope(child: PaperDocApp()));
}

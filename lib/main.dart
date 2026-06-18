import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/logging.dart';
import 'di/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  await configureDependencies();
  runApp(const ProviderScope(child: PaperDocApp()));
}

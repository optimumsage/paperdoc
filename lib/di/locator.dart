import 'package:get_it/get_it.dart';

import '../data/db/app_database.dart';

/// Service locator for non-widget singletons (database, services).
/// UI-facing state is handled by Riverpod; this holds the long-lived
/// infrastructure objects that Riverpod providers read from.
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerSingleton<AppDatabase>(AppDatabase());
  }
}

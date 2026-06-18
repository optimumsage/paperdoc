import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/share/share_intake.dart';
import 'app_providers.dart';
import 'router.dart';
import 'theme.dart';

class PaperDocApp extends ConsumerWidget {
  const PaperDocApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'PaperDoc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) =>
          ShareIntake(child: child ?? const SizedBox.shrink()),
    );
  }
}

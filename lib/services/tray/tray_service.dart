import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

/// Keeps PaperDoc running in the background on desktop: closing the window hides
/// it to a system-tray icon instead of quitting, and the tray's menu (or
/// left-click on Windows) brings it back. Android/web are unaffected.
class TrayService with TrayListener, WindowListener {
  TrayService._();

  static final TrayService instance = TrayService._();

  /// Tray + background behaviour only makes sense on Windows and macOS.
  static bool get isSupported =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS);

  Future<void> init() async {
    if (!isSupported) return;

    await windowManager.ensureInitialized();
    // Intercept the window's close button so we can hide to tray instead of
    // terminating the process.
    await windowManager.setPreventClose(true);
    windowManager.addListener(this);

    trayManager.addListener(this);
    await trayManager.setIcon(
      Platform.isWindows
          ? 'assets/tray/tray_icon.ico'
          : 'assets/tray/tray_icon.png',
    );
    await trayManager.setToolTip('PaperDoc');
    await trayManager.setContextMenu(Menu(items: [
      MenuItem(key: 'open', label: 'Open PaperDoc'),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: 'Quit'),
    ]));
  }

  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _quit() async {
    // Allow the close to actually terminate the app now.
    await windowManager.setPreventClose(false);
    await trayManager.destroy();
    await windowManager.destroy();
  }

  @override
  void onWindowClose() async {
    if (await windowManager.isPreventClose()) {
      await windowManager.hide();
    }
  }

  @override
  void onTrayIconMouseDown() {
    // Windows: a left click reopens the window. macOS: a click shows the menu.
    if (Platform.isWindows) {
      _showWindow();
    } else {
      trayManager.popUpContextMenu();
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'open':
        _showWindow();
      case 'quit':
        _quit();
    }
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

// 简化版托盘服务，暂不使用 tray_manager 的复杂 API
class TrayService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // TODO: 初始化系统托盘
      // tray_manager API 在不同版本有差异，后续适配
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize tray: $e');
    }
  }

  static Future<void> showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  static Future<void> hideWindow() async {
    await windowManager.hide();
  }

  static Future<void> quit() async {
    await windowManager.destroy();
  }

  static Future<bool> onWindowClose() async {
    await windowManager.hide();
    return false;
  }
}

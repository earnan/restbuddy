import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android 13+ 请求通知权限
    if (Platform.isAndroid) {
      await _requestAndroidPermission();
    }
  }

  static Future<void> _requestAndroidPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      debugPrint('Android notification permission granted: $granted');
    }
  }

  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      return true;
    } else if (Platform.isIOS || Platform.isMacOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? true;
    }
    return true;
  }

  static Future<void> showRestReminder({
    required String title,
    required String body,
    bool playSound = true,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'restbuddy_channel',
      '休息提醒',
      channelDescription: 'RestBuddy 定时休息提醒通知',
      importance: Importance.high,
      priority: Priority.high,
      playSound: playSound,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      title,
      body,
      details,
      payload: jsonEncode({'type': 'restbuddy'}),
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: 处理通知点击，打开休息弹窗
  }
}

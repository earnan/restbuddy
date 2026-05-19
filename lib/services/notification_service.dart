import 'dart:convert';
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
  }

  static Future<bool> requestPermission() async {
    final granted = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return granted ?? true;
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
    // TODO: 处理通知点击，打开休息弹窗
    debugPrint('Notification tapped: ${response.payload}');
  }
}

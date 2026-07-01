import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../routes/app_navigator_keys.dart';
import '../routes/route_names.dart';

// ============================================
// 🚀 TOP-LEVEL FUNCTION FOR BACKGROUND
// ============================================
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('🔔 Background notification tapped');
  debugPrint('Payload: ${response.payload}');

  final payload = response.payload;
  if (payload == null || payload.isEmpty) return;

  _handleNavigationFromPayload(payload);
}

// ============================================
// 🚀 TOP-LEVEL NAVIGATION HELPER (Single Details Page)
// ============================================
void _handleNavigationFromPayload(String payload) {
  final context = AppNavigatorKeys.currentContext;
  if (context == null) {
    debugPrint('⚠️ Context is null, cannot navigate');
    return;
  }

  debugPrint('📍 Navigating with payload: $payload');

  final parts = payload.split('|');
  final type = parts.isNotEmpty ? parts[0] : 'general';
  final id = parts.length > 1 ? parts[1] : '0';

  // ============================================
  // 🚀 NAVIGATE TO SINGLE DETAILS PAGE
  // ============================================
  context.push(
    RouteNames.notificationDetails,
    extra: {
      'notification_id': int.tryParse(id) ?? 0,
      'type': type,
      'title': 'Notification',
      'body': '',
    },
  );
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  int _notificationId = 0;

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'parent_hub_channel',
      'Parent Hub Notifications',
      description: 'General Notifications',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    debugPrint('✅ NotificationService initialized');
  }

  // ============================================
  // 🚀 FOREGROUND NOTIFICATION TAP
  // ============================================
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('🔔 Foreground notification clicked');
    debugPrint('Payload: ${response.payload}');

    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    _handleNavigationFromPayload(payload);
  }

  // ============================================
  // 🚀 SHOW LOCAL NOTIFICATION
  // ============================================
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'parent_hub_channel',
          'Parent Hub Notifications',
          channelDescription: 'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: true,
          playSound: true,
          enableVibration: true,
          styleInformation: const BigTextStyleInformation(''),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = ++_notificationId;

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload ?? 'general|0',
    );

    debugPrint('📱 Local notification displayed: $title');
  }

  // ============================================
  // 🚀 SCHEDULE NOTIFICATION
  // ============================================
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'parent_hub_channel',
          'Parent Hub Notifications',
          channelDescription: 'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: true,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = ++_notificationId;

    await _localNotifications.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
      payload: payload ?? 'general|0',
    );

    debugPrint('📅 Scheduled notification at: $scheduledTime');
  }

  // ============================================
  // 🚀 CANCEL NOTIFICATIONS
  // ============================================
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id: id);
    debugPrint('Notification cancelled: $id');
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    debugPrint('All notifications cancelled');
  }

  // ============================================
  // 🚀 GET PENDING NOTIFICATIONS
  // ============================================
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await _localNotifications.pendingNotificationRequests();
    debugPrint('Pending notifications: ${pending.length}');
    return pending;
  }
}
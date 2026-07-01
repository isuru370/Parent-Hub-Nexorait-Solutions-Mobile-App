import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../routes/app_navigator_keys.dart';
import '../routes/app_router.dart';
import 'notification_service.dart';

class FCMService {
  FCMService._();

  static final FCMService instance = FCMService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // ============================================
  // 🚀 NAVIGATION HANDLER (Using Helper)
  // ============================================
  void handleNavigation(Map<String, dynamic> data) {
    debugPrint('========== NAVIGATING FROM NOTIFICATION ==========');
    debugPrint('Data: $data');

    final context = AppNavigatorKeys.currentContext;
    if (context == null) {
      debugPrint('⚠️ Context is null, cannot navigate');
      return;
    }

    final String? type = data['type'];
    final String? notificationId = data['notification_id'];
    final String? title = data['title'];
    final String? body = data['body'];

    debugPrint('📱 Type: $type, ID: $notificationId');

    // ✅ Use NavigationHelper
    NavigationHelper.navigateToNotificationDetails(
      context,
      notificationId: int.tryParse(notificationId ?? '0') ?? 0,
      type: type ?? 'general',
      title: title ?? '',
      body: body ?? '',
    );
  }

  /// Initialize FCM
  Future<void> initialize() async {
    // Request notification permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('Permission Status: ${settings.authorizationStatus}');

    // Get FCM Token
    final token = await _messaging.getToken();

    debugPrint('==============================');
    debugPrint('FCM TOKEN');
    debugPrint(token);
    debugPrint('==============================');

    // Send token to backend
    if (token != null) {
      await _sendTokenToBackend(token);
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('New FCM Token: $newToken');
      _sendTokenToBackend(newToken);
    });

    // ============================================
    // 🚀 FOREGROUND MESSAGES
    // ============================================
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('📱 Foreground Notification');
      debugPrint('Title : ${message.notification?.title}');
      debugPrint('Body  : ${message.notification?.body}');
      debugPrint('Data  : ${message.data}');

      if (message.notification != null) {
        await NotificationService.instance.showNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: 'general|${message.data['notification_id'] ?? '0'}',
        );
      }
    });

    // ============================================
    // 🚀 USER TAPS NOTIFICATION (App in Foreground/Background)
    // ============================================
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📱 Notification Clicked (Foreground/Background)');
      debugPrint('Data: ${message.data}');

      // Navigate using the handler
      handleNavigation(message.data);
    });

    // ============================================
    // 🚀 APP OPENED FROM TERMINATED STATE
    // ============================================
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('📱 Opened From Terminated State');
      debugPrint('Data: ${initialMessage.data}');

      // Delay to ensure app is fully loaded
      Future.delayed(const Duration(milliseconds: 800), () {
        handleNavigation(initialMessage.data);
      });
    }
  }

  /// Send token to backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      // Your API call to save FCM token
      // await ApiService.saveFcmToken(token);
      debugPrint('Token sent to backend: $token');
    } catch (e) {
      debugPrint('Error sending token: $e');
    }
  }

  /// Return current FCM token
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  /// Subscribe to a topic
  Future<void> subscribe(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribe(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📱 Background Notification');
  debugPrint('Title : ${message.notification?.title}');
  debugPrint('Body  : ${message.notification?.body}');
  debugPrint('Data  : ${message.data}');
}
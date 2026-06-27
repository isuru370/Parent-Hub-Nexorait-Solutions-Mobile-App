import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'notification_service.dart';

class FCMService {
  FCMService._();

  static final FCMService instance = FCMService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

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

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('New FCM Token: $newToken');

      // TODO: Send the new token to your backend
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Foreground Notification');
      debugPrint('Title : ${message.notification?.title}');
      debugPrint('Body  : ${message.notification?.body}');
      debugPrint('Data  : ${message.data}');

      if (message.notification != null) {
        await NotificationService.instance.showNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
        );
      }
    });

    // User taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification Clicked');
      debugPrint('Data: ${message.data}');

      // TODO: Navigate to the required screen
    });

    // App opened from terminated state
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      debugPrint('Opened From Terminated State');
      debugPrint('Data: ${initialMessage.data}');

      // TODO: Navigate to the required screen
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
  debugPrint('Background Notification');
  debugPrint('Title : ${message.notification?.title}');
  debugPrint('Body  : ${message.notification?.body}');
  debugPrint('Data  : ${message.data}');
}

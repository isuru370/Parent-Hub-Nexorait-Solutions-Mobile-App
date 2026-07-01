class ApiEndpoints {
  ApiEndpoints._();

  /// Parent Hub

  static const parentHubBaseUrl = 'https://hub.nexorait.lk/api';

  //https://hub.nexorait.lk/api
  //http://172.29.140.230:9000/api

  // ============================================
  // AUTH
  // ============================================
  static const login = '$parentHubBaseUrl/v1/login';

  // ============================================
  // INSTITUTE API (Legacy)
  // ============================================

  static const studentProfile = '/api/student/profile';
  static const attendance = '/api/student/attendance';
  static const payments = '/api/student/payments';

  // ============================================
  // PARENT API
  // ============================================
  static const String logout = '/api/parent/v1/auth/logout';
  static const String changePassword = '/api/parent/v1/auth/change-password';
  static const String parentDashboard = '/api/parent/v1/dashboard';
  static const String parentAttendance = '/api/parent/v1/attendance';
  static const String parentPayment = '/api/parent/v1/payments';
  static const String parentExams = '/api/parent/v1/exams';
  static const String parentResult = '/api/parent/v1/results';
  static const String parentTeachers = '/api/parent/v1/teachers';
  static const String parentSchedule = '/api/parent/v1/schedule';

  // ============================================
  // FCM
  // ============================================
  static const saveFcmToken = '/api/parent/v1/fcm/token';
  static const logoutFcmToken = '/api/parent/v1/fcm/logout';

  // ============================================
  // NOTIFICATIONS
  // ============================================

  /// Base path
  static const String _notificationBase = '/api/parent/v1/notifications';

  /// Get all notifications (paginated)
  static const String notifications = _notificationBase;

  /// Get unread notifications
  static const String unreadNotifications = '$_notificationBase/unread';

  /// Get unread count
  static const String unreadCount = '$_notificationBase/unread/count';

  /// Mark all as read
  static const String markAllRead = '$_notificationBase/read-all';

  /// Delete all read notifications
  static const String deleteRead = '$_notificationBase/read/delete';

  /// Get notification statistics
  static const String notificationStats = '$_notificationBase/stats';

  // ============================================
  // 🚀 DYNAMIC ENDPOINTS (With ID)
  // ============================================

  /// Get single notification details
  /// Example: /api/parent/v1/notifications/123
  static String notificationDetails(int id) => '$_notificationBase/$id';

  /// Mark as read
  /// Example: /api/parent/v1/notifications/123/read
  static String markAsRead(int id) => '$_notificationBase/$id/read';

  /// Delete notification
  /// Example: /api/parent/v1/notifications/123
  static String deleteNotification(int id) => '$_notificationBase/$id';
}

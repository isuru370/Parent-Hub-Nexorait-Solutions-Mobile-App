class RouteNames {
  RouteNames._();

  // ============================================
  // AUTH & SPLASH
  // ============================================
  static const splash = '/';
  static const login = '/login';
  static const changePassword = '/change-password';

  // ============================================
  // MAIN DASHBOARD
  // ============================================
  static const dashboard = '/dashboard';
  static const attendance = '/attendance';
  static const payments = '/payments';
  static const profile = '/profile';
  static const settings = '/settings';
  static const String schedule = '/schedule';

  // ============================================
  // TEACHERS
  // ============================================
  static const String teachers = '/teachers';

  // ============================================
  // NESTED ROUTES (Inside Home)
  // ============================================
  static const exam = 'exams';
  static const result = 'results';

  // ============================================
  // 🚀 NOTIFICATION ROUTES
  // ============================================
  static const String notifications = '/notifications';
  static const String notificationDetails = '/notification-details';

  // ============================================
  // ⚠️ REMOVED - Not needed (Single Details Page)
  // ============================================
  // static const String paymentDetails = '/payment-details';
  // static const String attendanceDetails = '/attendance-details';
  // static const String examDetails = '/exam-details';
  // static const String resultDetails = '/result-details';
  // static const String announcementDetails = '/announcement-details';

  // ============================================
  // 🚀 HELPER METHODS
  // ============================================
  static String notificationDetailsWithId(int id) {
    return '$notificationDetails?notification_id=$id';
  }
}
class ApiEndpoints {
  ApiEndpoints._();

  /// Parent Hub

  static const parentHubBaseUrl = 'https://hub.nexorait.lk/api';

  //https://hub.nexorait.lk/api

  static const login = '$parentHubBaseUrl/v1/login';

  /// Institute API

  static const studentProfile = '/api/student/profile';
  static const attendance = '/api/student/attendance';
  static const payments = '/api/student/payments';

  static const String parentDashboard = '/api/parent/v1/dashboard';
  static const String parentAttendance = '/api/parent/v1/attendance';

  /// Firebase Cloud Messaging

  static const saveFcmToken = '/api/parent/v1/fcm/token';
  static const logoutFcmToken = '/api/parent/v1/fcm/logout';
}

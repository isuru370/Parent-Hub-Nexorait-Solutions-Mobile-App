import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../model/fcm/save_fcm_token_request.dart';
import '../model/fcm/save_fcm_token_response.dart';
import '../model/notification/notification_detail_response.dart';
import '../model/notification/notification_list_response.dart';
import '../model/notification/notification_model.dart';
import '../model/notification/operation_response.dart';
import '../model/notification/stats_response.dart';
import '../model/notification/unread_count_response.dart';

abstract class NotificationRemoteDataSource {
  // FCM
  Future<SaveFcmTokenResponse> saveToken(SaveFcmTokenRequest request);

  // Notifications
  Future<NotificationListResponse> getNotifications({
    String? status,
    String? type,
    String? dateFrom,
    String? dateTo,
    String? search,
    int? page,
    int? perPage,
  });

  Future<NotificationDetailResponse> getNotificationDetails(int id);

  Future<List<NotificationModel>> getUnreadNotifications({int? limit});

  Future<UnreadCountResponse> getUnreadCount();

  Future<OperationResponse> markAsRead(int id);

  Future<OperationResponse> markAllAsRead();

  Future<OperationResponse> deleteNotification(int id);

  Future<OperationResponse> deleteReadNotifications();

  Future<StatsResponse> getStats();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl({required this.apiClient});

  // ============================================
  // 🚀 HELPER: Get Student ID from Storage
  // ============================================
  int? _getStudentId() {
    final student = StorageService.getJson(StorageKeys.student);
    if (student == null) return null;
    return student['student_id'] as int?;
  }

  // ============================================
  // FCM TOKEN
  // ============================================
  @override
  Future<SaveFcmTokenResponse> saveToken(SaveFcmTokenRequest request) async {
    debugPrint('=========== SAVE FCM TOKEN ===========');
    debugPrint('Request : ${request.toJson()}');

    final response = await apiClient.post(
      ApiEndpoints.saveFcmToken,
      data: request.toJson(),
    );

    final result = SaveFcmTokenResponse.fromJson(response);

    debugPrint('Response: $response');
    debugPrint('Status  : ${result.status}');
    debugPrint('Message : ${result.message}');
    debugPrint('======================================');

    return result;
  }

  // ============================================
  // GET NOTIFICATIONS (POST)
  // ============================================
  @override
  Future<NotificationListResponse> getNotifications({
    String? status,
    String? type,
    String? dateFrom,
    String? dateTo,
    String? search,
    int? page = 1,
    int? perPage = 20,
  }) async {
    debugPrint('=========== GET NOTIFICATIONS ===========');

    // ✅ Get student_id from storage (using existing method)
    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    // ✅ Build request body
    final requestBody = <String, dynamic>{
      'student_id': studentId,
      'per_page': perPage,
      'page': page,
      if (status != null && status.isNotEmpty) 'status': status,
      if (type != null && type.isNotEmpty) 'type': type,
      if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
      if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    debugPrint('Student ID: $studentId');
    debugPrint('Request Body: $requestBody');

    final response = await apiClient.post(
      ApiEndpoints.notifications,
      data: requestBody,
    );

    debugPrint('Response: $response');

    return NotificationListResponse.fromJson(response);
  }

  // ============================================
  // GET NOTIFICATION DETAILS (POST)
  // ============================================
  @override
  Future<NotificationDetailResponse> getNotificationDetails(int id) async {
    debugPrint('=========== GET NOTIFICATION DETAILS ===========');
    debugPrint('Notification ID: $id');

    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    final requestBody = <String, dynamic>{'student_id': studentId};

    final response = await apiClient.post(
      ApiEndpoints.notificationDetails(id),
      data: requestBody,
    );

    return NotificationDetailResponse.fromJson(response);
  }

  // ============================================
  // GET UNREAD NOTIFICATIONS (POST)
  // ============================================
  @override
  Future<List<NotificationModel>> getUnreadNotifications({
    int? limit = 20,
  }) async {
    debugPrint('=========== GET UNREAD NOTIFICATIONS ===========');

    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    final requestBody = <String, dynamic>{
      'student_id': studentId,
      'limit': limit,
    };

    final response = await apiClient.post(
      ApiEndpoints.unreadNotifications,
      data: requestBody,
    );

    final result = NotificationListResponse.fromJson(response);
    return result.data?.items ?? [];
  }

  // ============================================
  // GET UNREAD COUNT (POST)
  // ============================================
  @override
  Future<UnreadCountResponse> getUnreadCount() async {
    debugPrint('=========== GET UNREAD COUNT ===========');

    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    final requestBody = <String, dynamic>{'student_id': studentId};

    final response = await apiClient.post(
      ApiEndpoints.unreadCount,
      data: requestBody,
    );

    return UnreadCountResponse.fromJson(response);
  }

  // ============================================
  // MARK AS READ (POST)
  // ============================================
  @override
  Future<OperationResponse> markAsRead(int id) async {
    debugPrint('=========== MARK AS READ ===========');
    debugPrint('Notification ID: $id');

    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    final requestBody = <String, dynamic>{'student_id': studentId};

    final response = await apiClient.post(
      ApiEndpoints.markAsRead(id),
      data: requestBody,
    );

    return OperationResponse.fromJson(response);
  }

  // ============================================
  // MARK ALL AS READ (POST)
  // ============================================
  @override
  Future<OperationResponse> markAllAsRead() async {
    debugPrint('=========== MARK ALL AS READ ===========');

    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    final requestBody = <String, dynamic>{'student_id': studentId};

    final response = await apiClient.post(
      ApiEndpoints.markAllRead,
      data: requestBody,
    );

    return OperationResponse.fromJson(response);
  }

  // ============================================
  // DELETE NOTIFICATION (POST)
  // ============================================
  @override
  Future<OperationResponse> deleteNotification(int id) async {
    debugPrint('=========== DELETE NOTIFICATION ===========');
    debugPrint('Notification ID: $id');

    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    final requestBody = <String, dynamic>{'student_id': studentId};

    final response = await apiClient.post(
      ApiEndpoints.deleteNotification(id),
      data: requestBody,
    );

    return OperationResponse.fromJson(response);
  }

  // ============================================
  // DELETE READ NOTIFICATIONS (POST)
  // ============================================
  @override
  Future<OperationResponse> deleteReadNotifications() async {
    debugPrint('=========== DELETE READ NOTIFICATIONS ===========');

    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    final requestBody = <String, dynamic>{'student_id': studentId};

    final response = await apiClient.post(
      ApiEndpoints.deleteRead,
      data: requestBody,
    );

    return OperationResponse.fromJson(response);
  }

  // ============================================
  // GET STATS (POST)
  // ============================================
  @override
  Future<StatsResponse> getStats() async {
    debugPrint('=========== GET STATS ===========');

    final studentId = _getStudentId();

    if (studentId == null) {
      throw Exception('Student ID not found. Please login again.');
    }

    final requestBody = <String, dynamic>{'student_id': studentId};

    final response = await apiClient.post(
      ApiEndpoints.notificationStats,
      data: requestBody,
    );

    return StatsResponse.fromJson(response);
  }
}

import '../../domain/repository/notification_repository.dart';
import '../datasource/notification_remote_datasource.dart';
import '../model/fcm/save_fcm_token_request.dart';
import '../model/fcm/save_fcm_token_response.dart';
import '../model/notification/notification_model.dart';
import '../model/notification/notification_list_response.dart';
import '../model/notification/notification_detail_response.dart';
import '../model/notification/unread_count_response.dart';
import '../model/notification/operation_response.dart';
import '../model/notification/stats_response.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
  });

  // ============================================
  // FCM
  // ============================================
  @override
  Future<SaveFcmTokenResponse> saveToken(SaveFcmTokenRequest request) {
    return remoteDataSource.saveToken(request);
  }

  // ============================================
  // NOTIFICATIONS
  // ============================================

  @override
  Future<NotificationListResponse> getNotifications({
    String? status,
    String? type,
    String? dateFrom,
    String? dateTo,
    String? search,
    int? page,
    int? perPage,
  }) {
    return remoteDataSource.getNotifications(
      status: status,
      type: type,
      dateFrom: dateFrom,
      dateTo: dateTo,
      search: search,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<NotificationDetailResponse> getNotificationDetails(int id) {
    return remoteDataSource.getNotificationDetails(id);
  }

  @override
  Future<List<NotificationModel>> getUnreadNotifications({int? limit}) {
    return remoteDataSource.getUnreadNotifications(limit: limit);
  }

  @override
  Future<UnreadCountResponse> getUnreadCount() {
    return remoteDataSource.getUnreadCount();
  }

  @override
  Future<OperationResponse> markAsRead(int id) {
    return remoteDataSource.markAsRead(id);
  }

  @override
  Future<OperationResponse> markAllAsRead() {
    return remoteDataSource.markAllAsRead();
  }

  @override
  Future<OperationResponse> deleteNotification(int id) {
    return remoteDataSource.deleteNotification(id);
  }

  @override
  Future<OperationResponse> deleteReadNotifications() {
    return remoteDataSource.deleteReadNotifications();
  }

  @override
  Future<StatsResponse> getStats() {
    return remoteDataSource.getStats();
  }
}
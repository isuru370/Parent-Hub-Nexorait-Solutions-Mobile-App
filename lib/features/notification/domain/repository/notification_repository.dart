import '../../data/model/fcm/save_fcm_token_request.dart';
import '../../data/model/fcm/save_fcm_token_response.dart';
import '../../data/model/notification/notification_model.dart';
import '../../data/model/notification/notification_list_response.dart';
import '../../data/model/notification/notification_detail_response.dart';
import '../../data/model/notification/unread_count_response.dart';
import '../../data/model/notification/operation_response.dart';
import '../../data/model/notification/stats_response.dart';

abstract class NotificationRepository {
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
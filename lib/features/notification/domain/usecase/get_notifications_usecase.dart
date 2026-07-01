import '../../data/model/notification/notification_list_response.dart';
import '../repository/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase({required this.repository});

  Future<NotificationListResponse> call({
    String? status,
    String? type,
    String? dateFrom,
    String? dateTo,
    String? search,
    int? page = 1,
    int? perPage = 20,
  }) {
    return repository.getNotifications(
      status: status,
      type: type,
      dateFrom: dateFrom,
      dateTo: dateTo,
      search: search,
      page: page,
      perPage: perPage,
    );
  }
}
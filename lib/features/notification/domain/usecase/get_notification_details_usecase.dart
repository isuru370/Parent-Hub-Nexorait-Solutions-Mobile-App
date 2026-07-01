import '../../data/model/notification/notification_detail_response.dart';
import '../repository/notification_repository.dart';

class GetNotificationDetailsUseCase {
  final NotificationRepository repository;

  GetNotificationDetailsUseCase({required this.repository});

  Future<NotificationDetailResponse> call(int id) {
    return repository.getNotificationDetails(id);
  }
}
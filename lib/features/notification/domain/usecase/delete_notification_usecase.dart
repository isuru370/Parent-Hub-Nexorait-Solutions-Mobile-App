import '../../data/model/notification/operation_response.dart';
import '../repository/notification_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase({required this.repository});

  Future<OperationResponse> call(int id) {
    return repository.deleteNotification(id);
  }
}
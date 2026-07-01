import '../../data/model/notification/operation_response.dart';
import '../repository/notification_repository.dart';

class DeleteReadNotificationsUseCase {
  final NotificationRepository repository;

  DeleteReadNotificationsUseCase({required this.repository});

  Future<OperationResponse> call() {
    return repository.deleteReadNotifications();
  }
}
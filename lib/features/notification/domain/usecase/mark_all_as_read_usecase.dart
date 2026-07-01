import '../../data/model/notification/operation_response.dart';
import '../repository/notification_repository.dart';

class MarkAllAsReadUseCase {
  final NotificationRepository repository;

  MarkAllAsReadUseCase({required this.repository});

  Future<OperationResponse> call() {
    return repository.markAllAsRead();
  }
}
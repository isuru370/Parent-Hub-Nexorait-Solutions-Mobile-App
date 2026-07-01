import '../../data/model/notification/operation_response.dart';
import '../repository/notification_repository.dart';

class MarkAsReadUseCase {
  final NotificationRepository repository;

  MarkAsReadUseCase({required this.repository});

  Future<OperationResponse> call(int id) {
    return repository.markAsRead(id);
  }
}
import '../../data/model/notification/unread_count_response.dart';
import '../repository/notification_repository.dart';

class GetUnreadCountUseCase {
  final NotificationRepository repository;

  GetUnreadCountUseCase({required this.repository});

  Future<UnreadCountResponse> call() {
    return repository.getUnreadCount();
  }
}
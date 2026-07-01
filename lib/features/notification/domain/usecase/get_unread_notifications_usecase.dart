import '../../data/model/notification/notification_model.dart';
import '../repository/notification_repository.dart';

class GetUnreadNotificationsUseCase {
  final NotificationRepository repository;

  GetUnreadNotificationsUseCase({required this.repository});

  Future<List<NotificationModel>> call({int? limit = 20}) {
    return repository.getUnreadNotifications(limit: limit);
  }
}
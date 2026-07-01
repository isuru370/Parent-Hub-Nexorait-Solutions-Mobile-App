import '../../data/model/notification/stats_response.dart';
import '../repository/notification_repository.dart';

class GetStatsUseCase {
  final NotificationRepository repository;

  GetStatsUseCase({required this.repository});

  Future<StatsResponse> call() {
    return repository.getStats();
  }
}
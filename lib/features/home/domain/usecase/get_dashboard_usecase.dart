import '../../data/model/dashboard_response_model.dart';
import '../repository/home_repository.dart';

class GetDashboardUseCase {
  final HomeRepository repository;

  GetDashboardUseCase({required this.repository});

  Future<DashboardResponseModel> call() {
    return repository.getDashboard();
  }
}

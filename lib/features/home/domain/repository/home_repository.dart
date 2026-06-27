import '../../data/model/dashboard_response_model.dart';

abstract class HomeRepository {
  Future<DashboardResponseModel> getDashboard();
}
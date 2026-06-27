import '../../domain/repository/home_repository.dart';
import '../datasource/home_remote_datasource.dart';
import '../model/dashboard_response_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardResponseModel> getDashboard() {
    return remoteDataSource.getDashboard();
  }
}

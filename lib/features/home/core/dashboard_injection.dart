
import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/home_remote_datasource.dart';
import '../data/repository/home_repository_impl.dart';
import '../domain/repository/home_repository.dart';
import '../domain/usecase/get_dashboard_usecase.dart';
import '../presentation/bloc/dashboard/dashboard_bloc.dart';


Future<void> initDashboardDI() async {
  /// DataSource
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl<HomeRemoteDataSource>()),
  );

  /// UseCase
  sl.registerLazySingleton(() => GetDashboardUseCase(repository: sl()));

  /// Bloc
  sl.registerFactory(
    () => DashboardBloc(getDashboardUseCase: sl<GetDashboardUseCase>()),
  );
}

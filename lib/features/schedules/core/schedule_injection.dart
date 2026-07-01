// lib/features/schedules/core/schedule_injection.dart

import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/schedule_remote_datasource.dart';
import '../data/repository/schedule_repository_impl.dart';
import '../domain/repository/schedule_repository.dart';
import '../domain/usecase/get_schedules_usecase.dart';
import '../presentation/bloc/schedule/schedule_bloc.dart';


Future<void> initScheduleDI() async {
  /// DataSource
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDataSource: sl<ScheduleRemoteDataSource>()),
  );

  /// UseCase
  sl.registerLazySingleton(
    () => GetSchedulesUseCase(repository: sl<ScheduleRepository>()),
  );

  /// Bloc
  sl.registerFactory(
    () => ScheduleBloc(
      getSchedulesUseCase: sl<GetSchedulesUseCase>(),
    ),
  );
}
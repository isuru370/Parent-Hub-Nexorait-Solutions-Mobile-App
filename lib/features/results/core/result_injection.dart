// lib/features/results/core/result_injection.dart

import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/result_remote_datasource.dart';
import '../data/repository/result_repository_impl.dart';
import '../domain/repository/result_repository.dart';
import '../domain/usecase/get_result_usecase.dart';
import '../presentation/bloc/result/result_bloc.dart';

Future<void> initResultDI() async {
  /// DataSource
  sl.registerLazySingleton<ResultRemoteDataSource>(
    () => ResultRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<ResultRepository>(
    () => ResultRepositoryImpl(remoteDataSource: sl<ResultRemoteDataSource>()),
  );

  /// UseCase
  sl.registerLazySingleton(
    () => GetResultUseCase(repository: sl<ResultRepository>()),
  );

  /// Bloc
  sl.registerFactory(
    () => ResultBloc(getResultUseCase: sl<GetResultUseCase>()),
  );
}

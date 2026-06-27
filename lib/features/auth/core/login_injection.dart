
import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../notification/domain/usecase/save_fcm_token_usecase.dart';
import '../data/datasource/auth_remote_datasource.dart';
import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/usecase/login_usecase.dart';
import '../presentation/bloc/auth/auth_bloc.dart';

Future<void> initAuthDI() async {
  /// DataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  /// UseCase
  sl.registerLazySingleton(
    () => LoginUseCase(repository: sl<AuthRepository>()),
  );

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      saveFcmTokenUseCase: sl<SaveFcmTokenUseCase>(),
    ),
  );
}

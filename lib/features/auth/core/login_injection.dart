import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../notification/domain/usecase/save_fcm_token_usecase.dart';
import '../data/datasource/auth_remote_datasource.dart';
import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/usecase/change_password_usecase.dart';
import '../domain/usecase/login_usecase.dart';
import '../domain/usecase/logout_usecase.dart';
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

  /// Login UseCase
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: sl<AuthRepository>()),
  );

  // change password use case
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(repository: sl<AuthRepository>()),
  );

  /// Logout UseCase
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(repository: sl<AuthRepository>()),
  );

  /// Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      saveFcmTokenUseCase: sl<SaveFcmTokenUseCase>(),
      changePasswordUseCase: sl<ChangePasswordUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );
}

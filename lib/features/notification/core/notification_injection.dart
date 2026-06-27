import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/notification_remote_datasource.dart';
import '../data/repository/notification_repository_impl.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/usecase/save_fcm_token_usecase.dart';
import '../presentation/bloc/notification/notification_bloc.dart';

Future<void> initNotificationDI() async {
  /// DataSource
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl<NotificationRemoteDataSource>(),
    ),
  );

  /// UseCase
  sl.registerLazySingleton(() => SaveFcmTokenUseCase(repository: sl()));

  /// Bloc
  sl.registerFactory(
    () => NotificationBloc(saveFcmTokenUseCase: sl<SaveFcmTokenUseCase>()),
  );
}

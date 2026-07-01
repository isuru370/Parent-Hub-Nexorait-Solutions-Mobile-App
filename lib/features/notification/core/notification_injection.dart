import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/notification_remote_datasource.dart';
import '../data/repository/notification_repository_impl.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/usecase/delete_notification_usecase.dart';
import '../domain/usecase/delete_read_notifications_usecase.dart';
import '../domain/usecase/get_notification_details_usecase.dart';
import '../domain/usecase/get_notifications_usecase.dart';
import '../domain/usecase/get_stats_usecase.dart';
import '../domain/usecase/get_unread_count_usecase.dart';
import '../domain/usecase/get_unread_notifications_usecase.dart';
import '../domain/usecase/mark_all_as_read_usecase.dart';
import '../domain/usecase/mark_as_read_usecase.dart';
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

  /// UseCases
  sl.registerLazySingleton(() => SaveFcmTokenUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetNotificationsUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetNotificationDetailsUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetUnreadNotificationsUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetUnreadCountUseCase(repository: sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(repository: sl()));
  sl.registerLazySingleton(() => MarkAllAsReadUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteNotificationUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => DeleteReadNotificationsUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetStatsUseCase(repository: sl()));

  /// Bloc
  sl.registerFactory(
    () => NotificationBloc(
      saveFcmTokenUseCase: sl<SaveFcmTokenUseCase>(),
      getNotificationsUseCase: sl<GetNotificationsUseCase>(),
      getNotificationDetailsUseCase: sl<GetNotificationDetailsUseCase>(),
      getUnreadNotificationsUseCase: sl<GetUnreadNotificationsUseCase>(),
      getUnreadCountUseCase: sl<GetUnreadCountUseCase>(),
      markAsReadUseCase: sl<MarkAsReadUseCase>(),
      markAllAsReadUseCase: sl<MarkAllAsReadUseCase>(),
      deleteNotificationUseCase: sl<DeleteNotificationUseCase>(),
      deleteReadNotificationsUseCase: sl<DeleteReadNotificationsUseCase>(),
      getStatsUseCase: sl<GetStatsUseCase>(),
    ),
  );
}

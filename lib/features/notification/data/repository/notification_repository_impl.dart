import '../../domain/repository/notification_repository.dart';
import '../datasource/notification_remote_datasource.dart';
import '../model/save_fcm_token_request.dart';
import '../model/save_fcm_token_response.dart';

class NotificationRepositoryImpl
    implements NotificationRepository {

  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<SaveFcmTokenResponse> saveToken(
      SaveFcmTokenRequest request) {

    return remoteDataSource.saveToken(request);
  }
}
import '../../data/model/save_fcm_token_request.dart';
import '../../data/model/save_fcm_token_response.dart';

abstract class NotificationRepository {
  Future<SaveFcmTokenResponse> saveToken(
    SaveFcmTokenRequest request,
  );
}
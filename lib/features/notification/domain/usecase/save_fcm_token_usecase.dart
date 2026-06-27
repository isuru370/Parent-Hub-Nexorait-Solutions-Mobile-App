import '../../data/model/save_fcm_token_request.dart';
import '../../data/model/save_fcm_token_response.dart';
import '../repository/notification_repository.dart';

class SaveFcmTokenUseCase {

  final NotificationRepository repository;

  SaveFcmTokenUseCase({
    required this.repository,
  });

  Future<SaveFcmTokenResponse> call(
      SaveFcmTokenRequest request) {

    return repository.saveToken(request);
  }
}
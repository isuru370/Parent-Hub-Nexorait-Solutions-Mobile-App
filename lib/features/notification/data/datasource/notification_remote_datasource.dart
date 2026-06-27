import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/save_fcm_token_request.dart';
import '../model/save_fcm_token_response.dart';

abstract class NotificationRemoteDataSource {
  Future<SaveFcmTokenResponse> saveToken(SaveFcmTokenRequest request);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SaveFcmTokenResponse> saveToken(SaveFcmTokenRequest request) async {
    debugPrint('=========== SAVE FCM TOKEN ===========');
    debugPrint('Request : ${request.toJson()}');

    final response = await apiClient.post(
      ApiEndpoints.saveFcmToken,
      data: request.toJson(),
    );

    final result = SaveFcmTokenResponse.fromJson(response);

    debugPrint('Response: $response');
    debugPrint('Status  : ${result.status}');
    debugPrint('Message : ${result.message}');
    debugPrint('======================================');

    return result;
  }
}

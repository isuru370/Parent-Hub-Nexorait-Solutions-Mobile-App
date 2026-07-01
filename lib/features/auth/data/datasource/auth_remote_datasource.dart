import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/device_info_service.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';

import '../model/change_password_request.dart';
import '../model/change_password_response.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../model/logout_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(
    LoginRequestModel request,
  );

  Future<LogoutResponseModel> logout();

  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest request,
  );
}

class AuthRemoteDataSourceImpl
    implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<LoginResponseModel> login(
    LoginRequestModel request,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    final result = LoginResponseModel.fromJson(response);

    if (result.status) {
      await StorageService.setString(
        StorageKeys.apiUrl,
        result.apiUrl,
      );

      await StorageService.saveJson(
        StorageKeys.student,
        result.student?.toJson() ?? {},
      );

      await StorageService.setBool(
        StorageKeys.isLoggedIn,
        true,
      );
    }

    return result;
  }

  @override
  Future<LogoutResponseModel> logout() async {
    final student = StorageService.getJson(
      StorageKeys.student,
    );

    if (student == null) {
      throw Exception("Student data not found.");
    }

    final deviceId = await DeviceInfoService.getDeviceId();

    final response = await apiClient.post(
      ApiEndpoints.logout,
      data: {
        "student_id": student["student_id"],
        "device_id": deviceId,
      },
    );

    final result = LogoutResponseModel.fromJson(response);

    if (result.status) {
      await StorageService.clear();
    }

    return result;
  }

  @override
  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest request,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.changePassword,
      data: request.toJson(),
    );

    return ChangePasswordResponse.fromJson(
      response,
    );
  }
}
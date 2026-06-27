import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';



abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(
    LoginRequestModel request,
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

    final result = LoginResponseModel.fromJson(
      response,
    );

    debugPrint('LOGIN RESPONSE STATUS : ${result.status}');

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
}
// lib/features/results/data/datasource/result_remote_datasource.dart

import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/result_request_model.dart';
import '../model/result_response_model.dart';


abstract class ResultRemoteDataSource {
  Future<ResultResponseModel> getResult(ResultRequestModel request);
}

class ResultRemoteDataSourceImpl implements ResultRemoteDataSource {
  final ApiClient apiClient;

  ResultRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ResultResponseModel> getResult(ResultRequestModel request) async {
    debugPrint('========= GET RESULT =========');
    debugPrint('Request: ${request.toJson()}');

    final response = await apiClient.post(
      ApiEndpoints.parentResult,
      data: request.toJson(),
    );

    final result = ResultResponseModel.fromJson(response);

    debugPrint('Response: $response');
    debugPrint('Status  : ${result.status}');
    debugPrint('Message : ${result.message}');
    debugPrint('================================');

    return result;
  }
}
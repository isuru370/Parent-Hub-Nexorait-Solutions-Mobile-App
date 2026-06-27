import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../model/dashboard_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<DashboardResponseModel> getDashboard();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<DashboardResponseModel> getDashboard() async {
    debugPrint('========= GET DASHBOARD =========');

    final student = StorageService.getJson(StorageKeys.student);

    if (student == null) {
      throw Exception('Student data not found.');
    }

    final studentId = student['student_id'];

    if (studentId == null) {
      throw Exception('Student ID not found.');
    }

    debugPrint('Student ID : $studentId');

    final response = await apiClient.post(
      ApiEndpoints.parentDashboard,
      data: {
        'student_id': studentId,
      },
    );

    final result = DashboardResponseModel.fromJson(response);

    debugPrint('Request : {"student_id": $studentId}');
    debugPrint('Response: $response');
    debugPrint('Status  : ${result.status}');
    debugPrint('Message : ${result.message}');
    debugPrint('================================');

    return result;
  }
}
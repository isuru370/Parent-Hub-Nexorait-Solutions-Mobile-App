// lib/features/schedules/data/datasource/schedule_remote_datasource.dart

import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../model/schedule_response_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<ScheduleResponseModel> getSchedules();
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final ApiClient apiClient;

  ScheduleRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ScheduleResponseModel> getSchedules() async {
    debugPrint('========= GET SCHEDULES =========');

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
      ApiEndpoints.parentSchedule,
      data: {'student_id': studentId},
    );

    final result = ScheduleResponseModel.fromJson(response);

    debugPrint('Request : {"student_id": $studentId}');
    debugPrint('Response: $response');
    debugPrint('Success : ${result.success}');
    debugPrint('Message : ${result.message}');
    debugPrint('Total Schedules : ${result.data.length}');
    debugPrint('====================================');

    return result;
  }
}
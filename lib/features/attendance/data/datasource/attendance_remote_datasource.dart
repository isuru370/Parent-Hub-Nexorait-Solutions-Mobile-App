import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../model/attendance_response_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceResponseModel> getAttendance();
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final ApiClient apiClient;

  AttendanceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AttendanceResponseModel> getAttendance() async {
    debugPrint('========= GET ATTENDANCE =========');

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
      ApiEndpoints.parentAttendance,
      data: {'student_id': studentId},
    );

    final result = AttendanceResponseModel.fromJson(response);

    debugPrint('Request : {"student_id": $studentId}');

    debugPrint('Response: $response');

    debugPrint('Status  : ${result.status}');

    debugPrint('Message : ${result.message}');

    debugPrint('=================================');

    return result;
  }
}

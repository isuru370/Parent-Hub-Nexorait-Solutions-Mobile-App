// lib/features/teachers/data/datasource/teacher_remote_datasource.dart

import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../model/teacher_response_model.dart';

abstract class TeacherRemoteDataSource {
  Future<TeacherResponseModel> getTeachers();
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  final ApiClient apiClient;

  TeacherRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<TeacherResponseModel> getTeachers() async {
    debugPrint('========= GET TEACHERS =========');

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
      ApiEndpoints.parentTeachers,
      data: {'student_id': studentId}, //change student id
    );

    final result = TeacherResponseModel.fromJson(response);

    debugPrint('Request : {"student_id": $studentId}');
    debugPrint('Response: $response');
    debugPrint('Success : ${result.success}');
    debugPrint('Message : ${result.message}');
    debugPrint('Total Teachers : ${result.data.length}');
    debugPrint('====================================');

    return result;
  }
}

// lib/features/exams/data/datasource/exam_remote_datasource.dart

import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../model/exam_response_model.dart';

abstract class ExamRemoteDataSource {
  Future<ExamResponseModel> getExamList();
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final ApiClient apiClient;

  ExamRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ExamResponseModel> getExamList() async {
    debugPrint('========= GET EXAM LIST =========');

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
      ApiEndpoints.parentExams,
      data: {'student_id': studentId},
    );

    final result = ExamResponseModel.fromJson(response);

    debugPrint('Request : {"student_id": $studentId}');
    debugPrint('Response: $response');
    debugPrint('Status  : ${result.status}');
    debugPrint('Message : ${result.message}');
    debugPrint('Total Exams : ${result.data.summary.totalExams}');
    debugPrint('====================================');

    return result;
  }
}

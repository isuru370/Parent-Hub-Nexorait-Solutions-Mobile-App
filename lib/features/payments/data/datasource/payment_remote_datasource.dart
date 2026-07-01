// lib/features/payments/data/datasource/payment_remote_datasource.dart

import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../model/payment_response_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentResponseModel> getPaymentHistory();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient apiClient;

  PaymentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaymentResponseModel> getPaymentHistory() async {
    debugPrint('========= GET PAYMENT HISTORY =========');

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
      ApiEndpoints.parentPayment,
      data: {'student_id': studentId},
    );

    final result = PaymentResponseModel.fromJson(response);

    debugPrint('Request : {"student_id": $studentId}');
    debugPrint('Response: $response');
    debugPrint('Status  : ${result.status}');
    debugPrint('Message : ${result.message}');
    debugPrint('Total Payments : ${result.data.summary.totalPayments}');
    debugPrint('========================================');

    return result;
  }
}

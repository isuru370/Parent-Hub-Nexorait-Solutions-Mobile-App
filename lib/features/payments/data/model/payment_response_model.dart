// lib/features/payments/data/models/payment_response_model.dart

import 'payment_summary_model.dart';
import 'payment_class_model.dart';

class PaymentResponseModel {
  final bool status;
  final String message;
  final PaymentDataModel data;

  PaymentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: PaymentDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class PaymentDataModel {
  final PaymentSummaryModel summary;
  final List<PaymentClassModel> classes;

  PaymentDataModel({
    required this.summary,
    required this.classes,
  });

  factory PaymentDataModel.fromJson(Map<String, dynamic> json) {
    return PaymentDataModel(
      summary: PaymentSummaryModel.fromJson(json['summary'] ?? {}),
      classes: (json['classes'] as List? ?? [])
          .map((e) => PaymentClassModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'classes': classes.map((e) => e.toJson()).toList(),
    };
  }
}
// lib/features/exams/data/models/exam_response_model.dart

import 'exam_summary_model.dart';
import 'exam_class_model.dart';

class ExamResponseModel {
  final bool status;
  final String message;
  final ExamDataModel data;

  ExamResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExamResponseModel.fromJson(Map<String, dynamic> json) {
    return ExamResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ExamDataModel.fromJson(json['data'] ?? {}),
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

class ExamDataModel {
  final ExamSummaryModel summary;
  final List<ExamClassModel> classes;

  ExamDataModel({
    required this.summary,
    required this.classes,
  });

  factory ExamDataModel.fromJson(Map<String, dynamic> json) {
    return ExamDataModel(
      summary: ExamSummaryModel.fromJson(json['summary'] ?? {}),
      classes: (json['classes'] as List? ?? [])
          .map((e) => ExamClassModel.fromJson(e))
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
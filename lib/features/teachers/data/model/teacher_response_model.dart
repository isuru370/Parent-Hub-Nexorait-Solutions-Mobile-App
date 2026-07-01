// lib/features/teachers/data/models/teacher_response_model.dart

import 'teacher_model.dart';

class TeacherResponseModel {
  final bool success;
  final String message;
  final List<TeacherModel> data;

  TeacherResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TeacherResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => TeacherModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
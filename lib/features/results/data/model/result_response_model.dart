// lib/features/results/data/models/result_response_model.dart

import 'exam_detail_model.dart';
import 'student_result_model.dart';
import 'top_ranking_model.dart';

class ResultResponseModel {
  final bool status;
  final String message;
  final ResultDataModel? data;

  ResultResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory ResultResponseModel.fromJson(Map<String, dynamic> json) {
    return ResultResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ResultDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ResultDataModel {
  final ExamDetailModel exam;
  final StudentResultModel studentResult;
  final List<TopRankingModel> topRankings;

  ResultDataModel({
    required this.exam,
    required this.studentResult,
    required this.topRankings,
  });

  factory ResultDataModel.fromJson(Map<String, dynamic> json) {
    return ResultDataModel(
      exam: ExamDetailModel.fromJson(json['exam'] ?? {}),
      studentResult: StudentResultModel.fromJson(json['student_result'] ?? {}),
      topRankings: (json['top_rankings'] as List? ?? [])
          .map((e) => TopRankingModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam': exam.toJson(),
      'student_result': studentResult.toJson(),
      'top_rankings': topRankings.map((e) => e.toJson()).toList(),
    };
  }
}
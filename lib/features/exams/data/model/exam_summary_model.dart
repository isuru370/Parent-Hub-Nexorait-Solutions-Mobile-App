// lib/features/exams/data/models/exam_summary_model.dart

class ExamSummaryModel {
  final int totalClasses;
  final int totalExams;

  ExamSummaryModel({
    required this.totalClasses,
    required this.totalExams,
  });

  factory ExamSummaryModel.fromJson(Map<String, dynamic> json) {
    return ExamSummaryModel(
      totalClasses: json['total_classes'] ?? 0,
      totalExams: json['total_exams'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_classes': totalClasses,
      'total_exams': totalExams,
    };
  }
}
// lib/features/results/data/models/result_request_model.dart

class ResultRequestModel {
  final int studentId;
  final int examId;

  ResultRequestModel({
    required this.studentId,
    required this.examId,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'exam_id': examId,
    };
  }
}
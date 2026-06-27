import 'student_class_model.dart';
import 'category_model.dart';

class ExamModel {
  final int id;
  final String title;
  final DateTime examDate;
  final String startTime;
  final String endTime;
  final String status;
  final StudentClassModel studentClass;
  final CategoryModel category;

  ExamModel({
    required this.id,
    required this.title,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.studentClass,
    required this.category,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json["id"],
      title: json["title"],
      examDate: DateTime.parse(json["exam_date"]),
      startTime: json["start_time"],
      endTime: json["end_time"],
      status: json["status"],
      studentClass: StudentClassModel.fromJson(json["student_class"]),
      category: CategoryModel.fromJson(json["category"]),
    );
  }
}
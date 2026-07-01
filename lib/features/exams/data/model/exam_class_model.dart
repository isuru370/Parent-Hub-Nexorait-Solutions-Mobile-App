// lib/features/exams/data/models/exam_class_model.dart

import 'exam_model.dart';

class ExamClassModel {
  final int classId;
  final String className;
  final String subjectName;
  final String teacher;
  final int examCount;
  final List<ExamModel> exams;

  ExamClassModel({
    required this.classId,
    required this.className,
    required this.subjectName,
    required this.teacher,
    required this.examCount,
    required this.exams,
  });

  factory ExamClassModel.fromJson(Map<String, dynamic> json) {
    return ExamClassModel(
      classId: json['class_id'] ?? 0,
      className: json['class_name'] ?? '',
      subjectName: json['subject_name'] ?? '',
      teacher: json['teacher'] ?? '',
      examCount: json['exam_count'] ?? 0,
      exams: (json['exams'] as List? ?? [])
          .map((e) => ExamModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'subject_name': subjectName,
      'teacher': teacher,
      'exam_count': examCount,
      'exams': exams.map((e) => e.toJson()).toList(),
    };
  }
}
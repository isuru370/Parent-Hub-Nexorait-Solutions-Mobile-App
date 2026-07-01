// lib/features/schedules/data/models/student_class_model.dart

import 'teacher_model.dart';
import 'subject_model.dart';
import 'grade_model.dart';

class StudentClassModel {
  final int id;
  final String className;
  final int teacherId;
  final int subjectId;
  final int gradeId;
  final TeacherModel? teacher;
  final SubjectModel? subject;
  final GradeModel? grade;

  StudentClassModel({
    required this.id,
    required this.className,
    required this.teacherId,
    required this.subjectId,
    required this.gradeId,
    this.teacher,
    this.subject,
    this.grade,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: json['id'] ?? 0,
      className: json['class_name'] ?? '',
      teacherId: json['teacher_id'] ?? 0,
      subjectId: json['subject_id'] ?? 0,
      gradeId: json['grade_id'] ?? 0,
      teacher: json['teacher'] != null
          ? TeacherModel.fromJson(json['teacher'])
          : null,
      subject: json['subject'] != null
          ? SubjectModel.fromJson(json['subject'])
          : null,
      grade: json['grade'] != null
          ? GradeModel.fromJson(json['grade'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'teacher_id': teacherId,
      'subject_id': subjectId,
      'grade_id': gradeId,
      'teacher': teacher?.toJson(),
      'subject': subject?.toJson(),
      'grade': grade?.toJson(),
    };
  }
}
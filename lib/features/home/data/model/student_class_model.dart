import 'subject_model.dart';
import 'teacher_model.dart';

class StudentClassModel {
  final int id;
  final String className;
  final SubjectModel subject;
  final TeacherModel? teacher;

  StudentClassModel({
    required this.id,
    required this.className,
    required this.subject,
    this.teacher,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: json["id"],
      className: json["class_name"],
      subject: SubjectModel.fromJson(json["subject"]),
      teacher: json["teacher"] == null
          ? null
          : TeacherModel.fromJson(json["teacher"]),
    );
  }
}
import 'student_class_model.dart';

class ClassScheduleModel {
  final int id;
  final DateTime classDate;
  final String startTime;
  final String endTime;
  final String status;
  final String liveStatus;
  final StudentClassModel studentClass;

  ClassScheduleModel({
    required this.id,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.liveStatus,
    required this.studentClass,
  });

  factory ClassScheduleModel.fromJson(Map<String, dynamic> json) {
    return ClassScheduleModel(
      id: json["id"],
      classDate: DateTime.parse(json["class_date"]),
      startTime: json["start_time"],
      endTime: json["end_time"],
      status: json["status"],
      liveStatus: json["live_status"],
      studentClass: StudentClassModel.fromJson(json["student_class"]),
    );
  }
}
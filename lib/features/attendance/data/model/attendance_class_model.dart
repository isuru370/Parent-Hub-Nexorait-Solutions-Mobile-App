import 'attendance_history_model.dart';

class AttendanceClassModel {
  final int classId;
  final String className;
  final String categoryName;
  final String gradeName;
  final String teacher;

  final int totalSchedules;
  final int presentClasses;
  final int absentClasses;

  final double attendancePercentage;

  final List<AttendanceHistoryModel> attendanceHistory;

  AttendanceClassModel({
    required this.classId,
    required this.className,
    required this.categoryName,
    required this.gradeName,
    required this.teacher,
    required this.totalSchedules,
    required this.presentClasses,
    required this.absentClasses,
    required this.attendancePercentage,
    required this.attendanceHistory,
  });

  factory AttendanceClassModel.fromJson(
      Map<String, dynamic> json) {
    return AttendanceClassModel(
      classId: json['class_id'],
      className: json['class_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      gradeName: json['grade_name'] ?? '',
      teacher: json['teacher'] ?? '',
      totalSchedules: json['total_schedules'] ?? 0,
      presentClasses: json['present_classes'] ?? 0,
      absentClasses: json['absent_classes'] ?? 0,
      attendancePercentage:
          (json['attendance_percentage'] ?? 0).toDouble(),
      attendanceHistory: (json['attendance_history'] as List)
          .map((e) => AttendanceHistoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'category_name': categoryName,
      'grade_name': gradeName,
      'teacher': teacher,
      'total_schedules': totalSchedules,
      'present_classes': presentClasses,
      'absent_classes': absentClasses,
      'attendance_percentage': attendancePercentage,
      'attendance_history':
          attendanceHistory.map((e) => e.toJson()).toList(),
    };
  }
}
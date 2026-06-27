// lib/features/attendance/data/models/attendance_summary_model.dart

class AttendanceSummaryModel {
  final int totalSchedules;   // Total class sessions
  final int totalClasses;    // Total unique classes (subjects)
  final int presentClasses;
  final int absentClasses;
  final double attendancePercentage;

  AttendanceSummaryModel({
    required this.totalSchedules,
    required this.totalClasses,
    required this.presentClasses,
    required this.absentClasses,
    required this.attendancePercentage,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalSchedules: json['total_schedules'] ?? 0,
      totalClasses: json['total_classes'] ?? 0,
      presentClasses: json['present_classes'] ?? 0,
      absentClasses: json['absent_classes'] ?? 0,
      attendancePercentage:
          (json['attendance_percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_schedules': totalSchedules,
      'total_classes': totalClasses,
      'present_classes': presentClasses,
      'absent_classes': absentClasses,
      'attendance_percentage': attendancePercentage,
    };
  }
}
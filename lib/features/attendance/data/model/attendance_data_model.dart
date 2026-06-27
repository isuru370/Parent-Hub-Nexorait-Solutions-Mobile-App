import 'attendance_class_model.dart';
import 'attendance_summary_model.dart';

class AttendanceDataModel {
  final AttendanceSummaryModel summary;
  final List<AttendanceClassModel> classes;

  AttendanceDataModel({
    required this.summary,
    required this.classes,
  });

  factory AttendanceDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceDataModel(
      summary: AttendanceSummaryModel.fromJson(
        json['summary'] ?? {},
      ),
      classes: (json['classes'] as List? ?? [])
          .map(
            (e) => AttendanceClassModel.fromJson(e),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'classes': classes
          .map((e) => e.toJson())
          .toList(),
    };
  }
}
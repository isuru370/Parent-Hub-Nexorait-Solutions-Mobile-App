import 'marked_by_model.dart';

class AttendanceHistoryModel {
  final int scheduleId;
  final String classDate;
  final String startTime;
  final String endTime;
  final bool isPresent;

  final DateTime? attendedAt;

  final String? markMethod;

  final MarkedByModel? markedBy;

  AttendanceHistoryModel({
    required this.scheduleId,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.isPresent,
    this.attendedAt,
    this.markMethod,
    this.markedBy,
  });

  factory AttendanceHistoryModel.fromJson(
      Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      scheduleId: json['schedule_id'],
      classDate: json['class_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      isPresent: json['is_present'] ?? false,
      attendedAt: json['attended_at'] == null
          ? null
          : DateTime.parse(json['attended_at']),
      markMethod: json['mark_method'],
      markedBy: json['marked_by'] == null
          ? null
          : MarkedByModel.fromJson(json['marked_by']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule_id': scheduleId,
      'class_date': classDate,
      'start_time': startTime,
      'end_time': endTime,
      'is_present': isPresent,
      'attended_at': attendedAt?.toIso8601String(),
      'mark_method': markMethod,
      'marked_by': markedBy?.toJson(),
    };
  }
}
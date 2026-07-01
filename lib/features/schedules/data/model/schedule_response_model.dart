// lib/features/schedules/data/models/schedule_response_model.dart

import 'schedule_model.dart';

class ScheduleResponseModel {
  final bool success;
  final String message;
  final List<ScheduleModel> data;

  ScheduleResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => ScheduleModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  // ✅ Group schedules by class
  Map<String, List<ScheduleModel>> get groupedByClass {
    final map = <String, List<ScheduleModel>>{};
    for (final schedule in data) {
      final className = schedule.studentClass?.className ?? 'Unknown';
      if (!map.containsKey(className)) {
        map[className] = [];
      }
      map[className]!.add(schedule);
    }
    return map;
  }

  // ✅ Get unique classes
  List<String> get uniqueClasses {
    final classes = <String>{};
    for (final schedule in data) {
      if (schedule.studentClass?.className != null) {
        classes.add(schedule.studentClass!.className);
      }
    }
    return classes.toList()..sort();
  }
}
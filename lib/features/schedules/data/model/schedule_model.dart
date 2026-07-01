// lib/features/schedules/data/models/schedule_model.dart

import 'package:flutter/material.dart';

import 'student_class_model.dart';
import 'class_category_fee_model.dart';
import 'hall_model.dart';

class ScheduleModel {
  final int id;
  final int studentClassId;
  final int classCategoryFeeId;
  final int classHallId;
  final DateTime classDate;
  final String startTime;
  final String endTime;
  final String dayOfWeek;
  final String status;
  final String? note;
  final StudentClassModel? studentClass;
  final ClassCategoryFeeModel? classCategoryFee;
  final HallModel? hall;

  ScheduleModel({
    required this.id,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.classHallId,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.status,
    this.note,
    this.studentClass,
    this.classCategoryFee,
    this.hall,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? 0,
      studentClassId: json['student_class_id'] ?? 0,
      classCategoryFeeId: json['class_category_fee_id'] ?? 0,
      classHallId: json['class_hall_id'] ?? 0,
      classDate: DateTime.parse(json['class_date'] ?? DateTime.now().toIso8601String()),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      dayOfWeek: json['day_of_week'] ?? '',
      status: json['status'] ?? '',
      note: json['note'],
      studentClass: json['student_class'] != null
          ? StudentClassModel.fromJson(json['student_class'])
          : null,
      classCategoryFee: json['class_category_fee'] != null
          ? ClassCategoryFeeModel.fromJson(json['class_category_fee'])
          : null,
      hall: json['hall'] != null
          ? HallModel.fromJson(json['hall'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_class_id': studentClassId,
      'class_category_fee_id': classCategoryFeeId,
      'class_hall_id': classHallId,
      'class_date': classDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'day_of_week': dayOfWeek,
      'status': status,
      'note': note,
      'student_class': studentClass?.toJson(),
      'class_category_fee': classCategoryFee?.toJson(),
      'hall': hall?.toJson(),
    };
  }

  // =========================================================
  // HELPER GETTERS
  // =========================================================

  bool get isOngoing => status == 'ongoing';
  bool get isScheduled => status == 'scheduled';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  String get statusDisplay {
    switch (status) {
      case 'ongoing':
        return 'Ongoing';
      case 'scheduled':
        return 'Scheduled';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'ongoing':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'ongoing':
        return Icons.play_circle;
      case 'scheduled':
        return Icons.schedule;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String get timeRange => '$startTime - $endTime';
  
  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${classDate.day} ${months[classDate.month - 1]} ${classDate.year}';
  }

  String get dayDisplay {
    final days = {
      'monday': 'Mon',
      'tuesday': 'Tue',
      'wednesday': 'Wed',
      'thursday': 'Thu',
      'friday': 'Fri',
      'saturday': 'Sat',
      'sunday': 'Sun',
    };
    return days[dayOfWeek.toLowerCase()] ?? dayOfWeek;
  }
}
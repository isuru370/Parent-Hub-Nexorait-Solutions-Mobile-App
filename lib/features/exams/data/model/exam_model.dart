// lib/features/exams/data/models/exam_model.dart

import 'package:flutter/material.dart';

import 'exam_category_model.dart';
import 'exam_hall_model.dart';

class ExamModel {
  final int examId;
  final String title;
  final String examDate;
  final String startTime;
  final String endTime;
  final String status;
  final ExamCategoryModel category;
  final ExamHallModel hall;

  ExamModel({
    required this.examId,
    required this.title,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.category,
    required this.hall,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      examId: json['exam_id'] ?? 0,
      title: json['title'] ?? '',
      examDate: json['exam_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      status: json['status'] ?? '',
      category: ExamCategoryModel.fromJson(json['category'] ?? {}),
      hall: ExamHallModel.fromJson(json['hall'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_id': examId,
      'title': title,
      'exam_date': examDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'category': category.toJson(),
      'hall': hall.toJson(),
    };
  }

  // Helper getters
  bool get isCompleted => status == 'completed';
  bool get isScheduled => status == 'scheduled';
  bool get isOngoing => status == 'ongoing';
  bool get isCancelled => status == 'cancelled';

  String get statusDisplay {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'scheduled':
        return 'Scheduled';
      case 'ongoing':
        return 'Ongoing';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'ongoing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'scheduled':
        return Icons.schedule;
      case 'ongoing':
        return Icons.play_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
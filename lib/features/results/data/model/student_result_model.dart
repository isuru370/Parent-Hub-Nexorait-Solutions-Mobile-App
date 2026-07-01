// lib/features/results/data/models/student_result_model.dart

import 'package:flutter/material.dart';

class StudentResultModel {
  final int marks;
  final int maxMarks;
  final int percentage;
  final String grade;
  final int? rank; // ✅ Nullable
  final String status;
  final String? remark;
  final bool isAbsent;

  StudentResultModel({
    required this.marks,
    required this.maxMarks,
    required this.percentage,
    required this.grade,
    this.rank, // ✅ Can be null
    required this.status,
    this.remark,
    required this.isAbsent,
  });

  factory StudentResultModel.fromJson(Map<String, dynamic> json) {
    return StudentResultModel(
      marks: json['marks'] ?? 0,
      maxMarks: json['max_marks'] ?? 0,
      percentage: json['percentage'] ?? 0,
      grade: json['grade'] ?? 'N/A',
      rank: json['rank'], // ✅ Can be null
      status: json['status'] ?? 'N/A',
      remark: json['remark'],
      isAbsent: json['is_absent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'marks': marks,
      'max_marks': maxMarks,
      'percentage': percentage,
      'grade': grade,
      'rank': rank, // ✅ Can be null
      'status': status,
      'remark': remark,
      'is_absent': isAbsent,
    };
  }

  // =========================================================
  // HELPER GETTERS
  // =========================================================

  bool get isPassed => status == 'passed';
  bool get isFailed => status == 'failed';
  bool get hasRank => rank != null && rank! > 0;
  
  String get statusDisplay {
    if (isAbsent) return 'Absent';
    if (isPassed) return 'Passed';
    if (isFailed) return 'Failed';
    return status;
  }

  String get rankDisplay {
    if (hasRank) {
      return '#${rank!}';
    }
    return 'N/A';
  }

  Color get statusColor {
    if (isAbsent) return Colors.grey;
    if (isPassed) return Colors.green;
    if (isFailed) return Colors.red;
    return Colors.orange;
  }

  Color get gradeColor {
    switch (grade) {
      case 'A':
      case 'A+':
        return Colors.green;
      case 'B':
      case 'B+':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get gradeDisplay {
    if (grade.isEmpty) return 'N/A';
    return grade;
  }

  String get marksDisplay {
    return '$marks / $maxMarks';
  }

  String get percentageDisplay {
    return '${percentage}%';
  }
}
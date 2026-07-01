// lib/features/results/data/models/top_ranking_model.dart

import 'package:flutter/material.dart';

class TopRankingModel {
  final int rank;
  final StudentRankModel student;
  final int marks;
  final int maxMarks;
  final int percentage;
  final String grade;
  final bool isAbsent;

  TopRankingModel({
    required this.rank,
    required this.student,
    required this.marks,
    required this.maxMarks,
    required this.percentage,
    required this.grade,
    required this.isAbsent,
  });

  factory TopRankingModel.fromJson(Map<String, dynamic> json) {
    return TopRankingModel(
      rank: json['rank'] ?? 0,
      student: StudentRankModel.fromJson(json['student'] ?? {}),
      marks: json['marks'] ?? 0,
      maxMarks: json['max_marks'] ?? 0,
      percentage: json['percentage'] ?? 0,
      grade: json['grade'] ?? 'N/A',
      isAbsent: json['is_absent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'student': student.toJson(),
      'marks': marks,
      'max_marks': maxMarks,
      'percentage': percentage,
      'grade': grade,
      'is_absent': isAbsent,
    };
  }

  // =========================================================
  // HELPER GETTERS
  // =========================================================

  bool get isCurrentStudent => false; // Will be set when comparing

  Color get rankColor {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey; // Silver
      case 3:
        return Colors.brown; // Bronze
      default:
        return Colors.grey.shade400;
    }
  }

  IconData get rankIcon {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events;
      case 3:
        return Icons.emoji_events;
      default:
        return Icons.star;
    }
  }

  String get marksDisplay {
    return '$marks / $maxMarks';
  }

  String get percentageDisplay {
    return '${percentage}%';
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
}

class StudentRankModel {
  final int id;
  final String initialName;

  StudentRankModel({
    required this.id,
    required this.initialName,
  });

  factory StudentRankModel.fromJson(Map<String, dynamic> json) {
    return StudentRankModel(
      id: json['id'] ?? 0,
      initialName: json['initial_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initial_name': initialName,
    };
  }
}
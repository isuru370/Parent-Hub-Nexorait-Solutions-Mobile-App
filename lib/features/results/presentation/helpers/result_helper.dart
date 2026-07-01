// lib/features/results/presentation/helpers/result_helper.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ResultHelper {
  static Color getGradeColor(String grade) {
    switch (grade) {
      case 'A':
      case 'A+':
        return AppColors.success;
      case 'B':
      case 'B+':
        return AppColors.primaryBlue;
      case 'C':
        return AppColors.warning;
      case 'D':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  static Color getRankColor(int rank) {
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

  static String getStatusDisplay(String status, bool isAbsent) {
    if (isAbsent) return 'Absent';
    if (status == 'passed') return 'Passed';
    if (status == 'failed') return 'Failed';
    return status;
  }

  static Color getStatusColor(String status, bool isAbsent) {
    if (isAbsent) return Colors.grey;
    if (status == 'passed') return AppColors.success;
    if (status == 'failed') return AppColors.error;
    return AppColors.warning;
  }

  static IconData getStatusIcon(String status, bool isAbsent) {
    if (isAbsent) return Icons.person_off;
    if (status == 'passed') return Icons.emoji_events;
    if (status == 'failed') return Icons.sentiment_dissatisfied;
    return Icons.help;
  }

  static List<Color> getGradientColors(String status, bool isAbsent) {
    if (isAbsent) {
      return [Colors.grey.shade400, Colors.grey.shade600];
    }
    if (status == 'passed') {
      return [AppColors.success, Colors.green.shade700];
    }
    return [Colors.orange.shade400, Colors.red.shade500];
  }
}

// lib/features/attendance/presentation/widgets/attendance_summary_card.dart

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_fonts.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final int totalSchedules;
  final int totalClasses;
  final int presentClasses;
  final int absentClasses;
  final double attendancePercentage;

  const AttendanceSummaryCard({
    super.key,
    required this.totalSchedules,
    required this.totalClasses,
    required this.presentClasses,
    required this.absentClasses,
    required this.attendancePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.darkBlue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance Overview',
                      style: TextStyle(
                        fontFamily: AppFonts.heading,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      '$totalClasses Classes • $totalSchedules Sessions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // Percentage Circle
              _buildPercentageCircle(),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Bar
          _buildProgressBar(),

          const SizedBox(height: 16),

          // Stats Row - Updated with 4 items
          Row(
            children: [
              _buildStatItem(
                label: 'Present',
                value: presentClasses,
                icon: Icons.check_circle,
                color: AppColors.present,
              ),
              _buildDivider(),
              _buildStatItem(
                label: 'Absent',
                value: absentClasses,
                icon: Icons.cancel,
                color: AppColors.absent,
              ),
              _buildDivider(),
              _buildStatItem(
                label: 'Classes',
                value: totalClasses,
                icon: Icons.subject,
                color: AppColors.primaryGold,
              ),
              _buildDivider(),
              _buildStatItem(
                label: 'Sessions',
                value: totalSchedules,
                icon: Icons.calendar_month,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageCircle() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              value: attendancePercentage / 100,
              strokeWidth: 4,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryGold,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${attendancePercentage.round()}%',
                style: const TextStyle(
                  fontFamily: AppFonts.heading,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final presentPercentage = totalSchedules > 0
        ? (presentClasses / totalSchedules) * 100
        : 0.0;
    final absentPercentage = totalSchedules > 0
        ? (absentClasses / totalSchedules) * 100
        : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            Flexible(
              flex: presentPercentage.round(),
              child: Container(color: AppColors.present),
            ),
            Flexible(
              flex: absentPercentage.round(),
              child: Container(color: AppColors.absent),
            ),
            if (presentPercentage + absentPercentage < 100)
              Flexible(
                flex: (100 - presentPercentage - absentPercentage).round(),
                child: Container(color: Colors.white.withOpacity(0.2)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white.withOpacity(0.15),
    );
  }
}

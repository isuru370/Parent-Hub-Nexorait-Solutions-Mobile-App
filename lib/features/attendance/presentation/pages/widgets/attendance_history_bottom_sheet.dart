// lib/features/attendance/presentation/widgets/attendance_history_bottom_sheet.dart

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_fonts.dart';
import '../../../data/model/attendance_class_model.dart';
import 'attendance_history_tile.dart';

class AttendanceHistoryBottomSheet extends StatelessWidget {
  final AttendanceClassModel classItem;

  const AttendanceHistoryBottomSheet({super.key, required this.classItem});

  @override
  Widget build(BuildContext context) {
    final histories = classItem.attendanceHistory;
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Calculate dynamic height based on content
    final headerHeight = 180.0; // Header + Stats + Padding
    final tileHeight = 80.0; // Approximate height per history tile
    final maxHeight = screenHeight * 0.85; // Maximum 85% of screen

    // Calculate content height
    final contentHeight = histories.isEmpty
        ? 100.0 // Empty state height
        : (histories.length * tileHeight) + headerHeight;

    // Use min of content height and max height
    final sheetHeight = contentHeight > maxHeight ? maxHeight : contentHeight;

    return DraggableScrollableSheet(
      initialChildSize: (sheetHeight / screenHeight).clamp(0.3, 0.85),
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classItem.className,
                            style: TextStyle(
                              fontFamily: AppFonts.heading,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${classItem.categoryName} • Grade ${classItem.gradeName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${classItem.attendancePercentage.round()}%',
                        style: TextStyle(
                          fontFamily: AppFonts.heading,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildStatItem(
                      label: 'Present',
                      value: classItem.presentClasses,
                      color: AppColors.present,
                    ),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      label: 'Absent',
                      value: classItem.absentClasses,
                      color: AppColors.absent,
                    ),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      label: 'Total',
                      value: classItem.totalSchedules,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Divider(height: 1),

              // History List - Now scrollable only when needed
              Expanded(
                child: histories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 48,
                              color: AppColors.border,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No attendance history',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: histories.length,
                        itemBuilder: (context, index) {
                          final history = histories[index];
                          return AttendanceHistoryTile(
                            history: history,
                            isFirst: index == 0,
                            isLast: index == histories.length - 1,
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required String label,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

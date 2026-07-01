// lib/features/schedules/presentation/widgets/schedule_class_card.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/schedule_model.dart';
import 'schedule_card.dart';

class ScheduleClassCard extends StatelessWidget {
  final String className;
  final List<ScheduleModel> schedules;
  final VoidCallback onTap;

  const ScheduleClassCard({
    super.key,
    required this.className,
    required this.schedules,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusCounts = _getStatusCounts();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppColors.border.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.class_,
                      color: AppColors.primaryBlue,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          className,
                          style: TextStyle(
                            fontFamily: AppFonts.heading,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          '${schedules.length} schedules',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Summary
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Status Chips
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (statusCounts['ongoing']! > 0)
                    _buildStatusChip(
                      label: 'Ongoing',
                      count: statusCounts['ongoing']!,
                      color: Colors.green,
                    ),
                  if (statusCounts['scheduled']! > 0)
                    _buildStatusChip(
                      label: 'Scheduled',
                      count: statusCounts['scheduled']!,
                      color: AppColors.primaryBlue,
                    ),
                  if (statusCounts['completed']! > 0)
                    _buildStatusChip(
                      label: 'Completed',
                      count: statusCounts['completed']!,
                      color: Colors.purple,
                    ),
                  if (statusCounts['cancelled']! > 0)
                    _buildStatusChip(
                      label: 'Cancelled',
                      count: statusCounts['cancelled']!,
                      color: AppColors.error,
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Preview - Show first 2 schedules
              Column(
                children: schedules.take(2).map((schedule) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: ScheduleCard(
                      schedule: schedule,
                    ),
                  );
                }).toList(),
              ),

              if (schedules.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${schedules.length - 2} more schedules',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDisabled,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> _getStatusCounts() {
    final counts = {
      'ongoing': 0,
      'scheduled': 0,
      'completed': 0,
      'cancelled': 0,
    };

    for (final schedule in schedules) {
      if (counts.containsKey(schedule.status)) {
        counts[schedule.status] = counts[schedule.status]! + 1;
      }
    }

    return counts;
  }

  Widget _buildStatusChip({
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
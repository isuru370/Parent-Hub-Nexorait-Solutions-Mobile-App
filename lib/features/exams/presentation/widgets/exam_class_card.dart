// lib/features/exams/presentation/widgets/exam_class_card.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/exam_class_model.dart';

class ExamClassCard extends StatelessWidget {
  final ExamClassModel classItem;
  final VoidCallback onTap;

  const ExamClassCard({
    super.key,
    required this.classItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get status counts
    final completedCount = classItem.exams.where((e) => e.isCompleted).length;
    final scheduledCount = classItem.exams.where((e) => e.isScheduled).length;
    final ongoingCount = classItem.exams.where((e) => e.isOngoing).length;
    final cancelledCount = classItem.exams.where((e) => e.isCancelled).length;

    // Get next exam (first scheduled or ongoing)
    final nextExam = classItem.exams
        .where((e) => e.isScheduled || e.isOngoing)
        .toList()
        .firstOrNull;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // HEADER
              // =========================================================
              Row(
                children: [
                  // Class Icon
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
                          classItem.className,
                          style: const TextStyle(
                            fontFamily: AppFonts.heading,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${classItem.subjectName} • ${classItem.teacher}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  // Exam Count Badge
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
                    child: Text(
                      '${classItem.examCount}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // =========================================================
              // STATUS SUMMARY CHIPS
              // =========================================================
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (completedCount > 0)
                    _buildStatusChip(
                      label: 'Completed',
                      count: completedCount,
                      color: AppColors.success,
                    ),
                  if (scheduledCount > 0)
                    _buildStatusChip(
                      label: 'Scheduled',
                      count: scheduledCount,
                      color: AppColors.primaryBlue,
                    ),
                  if (ongoingCount > 0)
                    _buildStatusChip(
                      label: 'Ongoing',
                      count: ongoingCount,
                      color: AppColors.warning,
                    ),
                  if (cancelledCount > 0)
                    _buildStatusChip(
                      label: 'Cancelled',
                      count: cancelledCount,
                      color: AppColors.error,
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // =========================================================
              // NEXT EXAM (if available)
              // =========================================================
              if (nextExam != null) ...[
                const Divider(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.next_plan,
                      size: 14,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Next: ${nextExam.title}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: nextExam.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        nextExam.examDate,
                        style: TextStyle(
                          fontSize: 10,
                          color: nextExam.statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // =========================================================
              // TAP HINT
              // =========================================================
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.textDisabled,
                  ),
                  Text(
                    'Tap to view details',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
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

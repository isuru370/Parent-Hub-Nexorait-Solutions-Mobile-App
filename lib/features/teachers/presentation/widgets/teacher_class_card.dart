// lib/features/teachers/presentation/widgets/teacher_class_card.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/model/class_model.dart';

class TeacherClassCard extends StatelessWidget {
  final ClassModel classItem;

  const TeacherClassCard({super.key, required this.classItem});

  @override
  Widget build(BuildContext context) {
    // ✅ Debug: Check value
    print('🔴 Building TeacherClassCard for: ${classItem.className}');
    print('🔴 isMyClass: ${classItem.isMyClass}');
    print('🔴 isOngoing: ${classItem.isOngoing}');

    // ✅ Use isMyClass directly
    final isEnrolled = classItem.isMyClass;
    final isOngoing = classItem.isOngoing;
    final hasCategories = classItem.hasCategories;

    print('🟢 isEnrolled: $isEnrolled');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isEnrolled ? AppColors.success.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnrolled
              ? AppColors.success.withOpacity(0.5)
              : AppColors.border.withOpacity(0.3),
          width: isEnrolled ? 2 : 1,
        ),
        boxShadow: isEnrolled
            ? [
                BoxShadow(
                  color: AppColors.success.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // CLASS NAME ROW
          // =========================================================
          Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isEnrolled
                      ? AppColors.success.withOpacity(0.15)
                      : AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isEnrolled ? Icons.star : Icons.class_,
                  color: isEnrolled ? AppColors.success : AppColors.primaryBlue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  classItem.className,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isEnrolled ? FontWeight.w700 : FontWeight.w600,
                    color: isEnrolled
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              // ✅ Status Badge (Ongoing)
              if (isOngoing)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ongoing',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(width: 6),

              // Grade Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isEnrolled
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Gr. ${classItem.gradeName}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isEnrolled
                        ? AppColors.success
                        : AppColors.primaryOrange,
                  ),
                ),
              ),

              // ✅ Enrolled Badge - Show if isEnrolled is true
              if (isEnrolled) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Enrolled ✅',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // =========================================================
          // CATEGORIES
          // =========================================================
          if (hasCategories) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: classItem.categories.map((category) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isEnrolled
                        ? AppColors.success.withOpacity(0.08)
                        : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isEnrolled
                          ? AppColors.success.withOpacity(0.2)
                          : AppColors.border.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.book,
                        size: 12,
                        color: isEnrolled
                            ? AppColors.success
                            : AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        category.categoryName,
                        style: TextStyle(
                          fontSize: 12,
                          color: isEnrolled
                              ? AppColors.success
                              : AppColors.textSecondary,
                          fontWeight: isEnrolled
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // =========================================================
          // MEDIUM & TYPE
          // =========================================================
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildTag(
                icon: Icons.language,
                label: classItem.mediumDisplay,
                isEnrolled: isEnrolled,
              ),
              _buildTag(
                icon: Icons.assignment,
                label: classItem.typeDisplay,
                isEnrolled: isEnrolled,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required IconData icon,
    required String label,
    required bool isEnrolled,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isEnrolled ? Colors.white : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnrolled
              ? AppColors.success.withOpacity(0.15)
              : AppColors.border.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isEnrolled ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isEnrolled ? AppColors.success : AppColors.textSecondary,
              fontWeight: isEnrolled ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

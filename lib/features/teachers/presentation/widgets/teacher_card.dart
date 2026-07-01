// lib/features/teachers/presentation/widgets/teacher_card.dart

// Add this method and update the card

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/teacher_model.dart';
import 'teacher_details_bottom_sheet.dart';

class TeacherCard extends StatelessWidget {
  final TeacherModel teacher;

  const TeacherCard({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final hasMyClasses = teacher.hasMyClasses;
    final isMyTeacher = hasMyClasses;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isMyTeacher
              ? AppColors.success.withOpacity(0.5)
              : AppColors.border.withOpacity(0.3),
          width: isMyTeacher ? 2.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showTeacherDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isMyTeacher
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.success.withOpacity(0.06), Colors.white],
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================================================
                // HEADER (Same as before)
                // =========================================================
                Row(
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: isMyTeacher
                                ? const LinearGradient(
                                    colors: [AppColors.success, Colors.green],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      AppColors.primaryBlue,
                                      AppColors.darkBlue,
                                    ],
                                  ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              teacher.initials.isNotEmpty
                                  ? teacher.initials
                                        .substring(0, 1)
                                        .toUpperCase()
                                  : teacher.fullName
                                        .substring(0, 1)
                                        .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (isMyTeacher)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.success,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Teacher Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  teacher.fullName,
                                  style: TextStyle(
                                    fontFamily: AppFonts.heading,
                                    fontSize: 18,
                                    fontWeight: isMyTeacher
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isMyTeacher
                                        ? AppColors.success
                                        : AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              if (isMyTeacher)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.success.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'My Teacher ⭐',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            teacher.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                teacher.mobile,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: teacher.isActive
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: teacher.isActive
                              ? AppColors.success.withOpacity(0.3)
                              : AppColors.error.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: teacher.isActive
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            teacher.statusDisplay,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: teacher.isActive
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =========================================================
                // QUICK CLASS PREVIEW (Only first 2 classes)
                // =========================================================
                if (teacher.classes.isNotEmpty) ...[
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Class Preview
                  Row(
                    children: [
                      Icon(
                        Icons.class_,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${teacher.totalClasses} Class${teacher.totalClasses != 1 ? 'es' : ''}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Show first 2 class names as preview
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Show first 2 classes as chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: teacher.classes.take(2).map((classItem) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: classItem.isMyClass
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: classItem.isMyClass
                                ? AppColors.success.withOpacity(0.2)
                                : AppColors.border.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              classItem.isMyClass ? Icons.star : Icons.class_,
                              size: 12,
                              color: classItem.isMyClass
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              classItem.className,
                              style: TextStyle(
                                fontSize: 12,
                                color: classItem.isMyClass
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                                fontWeight: classItem.isMyClass
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (teacher.classes.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${teacher.classes.length - 2} more classes',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textDisabled,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],

                // =========================================================
                // NO CLASSES
                // =========================================================
                if (teacher.classes.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'No classes assigned',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SHOW BOTTOM SHEET
  // =========================================================

  void _showTeacherDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TeacherDetailsBottomSheet(teacher: teacher),
    );
  }
}

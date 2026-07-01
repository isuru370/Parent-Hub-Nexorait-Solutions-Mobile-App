// lib/features/teachers/presentation/widgets/teacher_details_bottom_sheet.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/teacher_model.dart';
import 'teacher_class_card.dart';

class TeacherDetailsBottomSheet extends StatelessWidget {
  final TeacherModel teacher;

  const TeacherDetailsBottomSheet({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final hasMyClasses = teacher.hasMyClasses;
    final myClasses = teacher.myClasses;
    final otherClasses = teacher.otherClasses;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // =========================================================
              // HANDLE
              // =========================================================
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

              // =========================================================
              // HEADER
              // =========================================================
              _buildHeader(context),

              const SizedBox(height: 16),

              // =========================================================
              // STATS
              // =========================================================
              _buildStats(),

              const SizedBox(height: 16),

              const Divider(height: 1),

              // =========================================================
              // CLASS LIST
              // =========================================================
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // My Classes Section
                    if (hasMyClasses) ...[
                      _buildSectionHeader(
                        title: 'My Classes',
                        subtitle: 'Classes your child is enrolled in',
                        icon: Icons.star,
                        color: AppColors.success,
                        count: myClasses.length,
                      ),
                      const SizedBox(height: 8),
                      ...myClasses.map((classItem) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TeacherClassCard(classItem: classItem),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],

                    // Other Classes Section
                    if (otherClasses.isNotEmpty) ...[
                      _buildSectionHeader(
                        title: 'Other Classes',
                        subtitle: 'Classes taught by this teacher',
                        icon: Icons.class_,
                        color: AppColors.primaryBlue,
                        count: otherClasses.length,
                      ),
                      const SizedBox(height: 8),
                      ...otherClasses.map((classItem) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TeacherClassCard(classItem: classItem),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],

                    // No Classes
                    if (teacher.classes.isEmpty) ...[
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.class_outlined,
                              size: 48,
                              color: AppColors.textDisabled,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No classes assigned',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader(BuildContext context) {
    final isMyTeacher = teacher.hasMyClasses;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: isMyTeacher
                  ? const LinearGradient(
                      colors: [AppColors.success, Colors.green],
                    )
                  : const LinearGradient(
                      colors: [AppColors.primaryBlue, AppColors.darkBlue],
                    ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                teacher.initials.isNotEmpty
                    ? teacher.initials.substring(0, 1).toUpperCase()
                    : teacher.fullName.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
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
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (isMyTeacher)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'My Teacher',
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
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.email, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      teacher.email,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      teacher.mobile,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                // Status
                Row(
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
                        fontWeight: FontWeight.w500,
                        color: teacher.isActive
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // STATS
  // =========================================================

  Widget _buildStats() {
    final hasMyClasses = teacher.hasMyClasses;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatItem(
            label: 'Total Classes',
            value: teacher.totalClasses.toString(),
            icon: Icons.class_,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 8),
          _buildStatItem(
            label: 'My Classes',
            value: teacher.myClasses.length.toString(),
            icon: Icons.star,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          _buildStatItem(
            label: 'Status',
            value: teacher.isActive ? 'Active' : 'Inactive',
            icon: teacher.isActive ? Icons.check_circle : Icons.cancel,
            color: teacher.isActive ? AppColors.success : AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.15), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SECTION HEADER
  // =========================================================

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int count,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.heading,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

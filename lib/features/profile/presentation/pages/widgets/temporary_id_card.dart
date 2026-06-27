// lib/features/profile/presentation/widgets/temporary_id_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_fonts.dart';
import '../../../../auth/data/model/student_model.dart';

class TemporaryIdCard extends StatelessWidget {
  final StudentModel student;

  const TemporaryIdCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
      ),
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
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.qr_code,
                    color: AppColors.primaryOrange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temporary ID',
                        style: TextStyle(
                          fontFamily: AppFonts.heading,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Use this ID for quick check-in',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: student.temporaryIdStatusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: student.temporaryIdStatusColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    student.temporaryIdStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: student.temporaryIdStatusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Temporary ID
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID Code',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student.hasTemporaryId
                              ? student.temporaryId
                              : 'Not Available',
                          style: TextStyle(
                            fontFamily: AppFonts.heading,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: student.hasTemporaryId
                                ? AppColors.textPrimary
                                : AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (student.hasTemporaryId)
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: student.temporaryId),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Temporary ID copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: AppColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Expiry Info
            if (student.temporaryIdExpire != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 14,
                    color: student.isTemporaryIdExpired
                        ? AppColors.error
                        : AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      student.temporaryIdExpireDisplay,
                      style: TextStyle(
                        fontSize: 12,
                        color: student.isTemporaryIdExpired
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    student.temporaryIdExpireDateDisplay,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ],

            // Permanent QR Note
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is a temporary QR code. Use it for attendance marking.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

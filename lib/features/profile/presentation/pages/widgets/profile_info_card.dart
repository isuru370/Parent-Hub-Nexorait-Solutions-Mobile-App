// lib/features/profile/presentation/widgets/profile_info_card.dart

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../auth/data/model/student_model.dart';

class ProfileInfoCard extends StatelessWidget {
  final StudentModel student;

  const ProfileInfoCard({super.key, required this.student});

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
          children: [
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Mobile',
              value: student.mobile,
            ),
            const Divider(height: 16),
            _buildInfoRow(
              icon: Icons.message,
              label: 'WhatsApp',
              value: student.whatsappMobile,
            ),
            const Divider(height: 16),
            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: student.email,
            ),
            const Divider(height: 16),
            _buildInfoRow(
              icon: Icons.person,
              label: 'Gender',
              value: student.genderDisplay,
            ),
            if (student.nic != null) ...[
              const Divider(height: 16),
              _buildInfoRow(
                icon: Icons.credit_card,
                label: 'NIC',
                value: student.nic!,
              ),
            ],
            if (student.bday != null) ...[
              const Divider(height: 16),
              _buildInfoRow(
                icon: Icons.cake,
                label: 'Birthday',
                value: _formatDate(student.bday!),
              ),
            ],
            if (student.hasAddress) ...[
              const Divider(height: 16),
              _buildInfoRow(
                icon: Icons.location_on,
                label: 'Address',
                value: student.fullAddress,
                multiline: true,
              ),
            ],
            if (student.studentSchool != null) ...[
              const Divider(height: 16),
              _buildInfoRow(
                icon: Icons.school,
                label: 'School',
                value: student.studentSchool!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool multiline = false,
  }) {
    return Row(
      crossAxisAlignment: multiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: multiline ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

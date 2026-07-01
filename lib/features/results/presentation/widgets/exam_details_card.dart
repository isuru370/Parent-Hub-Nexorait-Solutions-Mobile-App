// lib/features/results/presentation/widgets/exam_details_card.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/exam_detail_model.dart';

class ExamDetailsCard extends StatelessWidget {
  final ExamDetailModel exam;

  const ExamDetailsCard({
    super.key,
    required this.exam,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Exam Details',
                style: TextStyle(
                  fontFamily: AppFonts.heading,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.book,
            label: 'Category',
            value: exam.category.categoryName,
          ),
          _buildInfoRow(
            icon: Icons.subject,
            label: 'Subject',
            value: exam.subject.subjectName,
          ),
          _buildInfoRow(
            icon: Icons.person,
            label: 'Teacher',
            value: exam.teacher.fullName,
          ),
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Hall',
            value: exam.hall.hallName,
          ),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: exam.examDate,
          ),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Time',
            value: '${exam.startTime} - ${exam.endTime}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
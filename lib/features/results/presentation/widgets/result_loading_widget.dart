// lib/features/results/presentation/widgets/result_loading_widget.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ResultLoadingWidget extends StatelessWidget {
  const ResultLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryBlue,
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          Text(
            'Loading your result...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
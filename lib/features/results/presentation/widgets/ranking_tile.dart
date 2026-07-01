// lib/features/results/presentation/widgets/ranking_tile.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/model/top_ranking_model.dart';
import '../helpers/result_helper.dart';

class RankingTile extends StatelessWidget {
  final TopRankingModel ranking;
  final bool isCurrentStudent;

  const RankingTile({
    super.key,
    required this.ranking,
    required this.isCurrentStudent,
  });

  @override
  Widget build(BuildContext context) {
    final rankColor = ResultHelper.getRankColor(ranking.rank);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isCurrentStudent
            ? AppColors.primaryBlue.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isCurrentStudent
            ? Border.all(
                color: AppColors.primaryBlue.withOpacity(0.3),
                width: 1.5,
              )
            : Border.all(color: Colors.transparent, width: 0),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${ranking.rank}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Student Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ranking.student.initialName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isCurrentStudent ? FontWeight.bold : FontWeight.w500,
                    color: isCurrentStudent ? AppColors.primaryBlue : AppColors.textPrimary,
                  ),
                ),
                if (isCurrentStudent)
                  Text(
                    'You',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Marks & Grade
          if (!ranking.isAbsent) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${ranking.marks}/${ranking.maxMarks}',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ResultHelper.getGradeColor(ranking.grade).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                ranking.grade,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ResultHelper.getGradeColor(ranking.grade),
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Absent',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
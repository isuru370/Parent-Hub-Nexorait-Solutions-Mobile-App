// lib/features/results/presentation/widgets/top_rankings_card.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/top_ranking_model.dart';
import 'ranking_tile.dart';

class TopRankingsCard extends StatelessWidget {
  final List<TopRankingModel> rankings;
  final int studentRank;

  const TopRankingsCard({
    super.key,
    required this.rankings,
    required this.studentRank,
  });

  @override
  Widget build(BuildContext context) {
    final hasRank = studentRank > 0;

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
              const Icon(
                Icons.emoji_events,
                color: AppColors.primaryGold,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Top Rankings',
                style: TextStyle(
                  fontFamily: AppFonts.heading,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (hasRank)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Your Rank: #$studentRank',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...rankings.map((ranking) {
            final isCurrentStudent = ranking.rank == studentRank;
            return RankingTile(
              ranking: ranking,
              isCurrentStudent: isCurrentStudent,
            );
          }),
        ],
      ),
    );
  }
}
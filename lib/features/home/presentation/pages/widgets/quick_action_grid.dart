import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.0,
      children: [
        _ActionCard(
          title: "Attendance",
          icon: Icons.fact_check_rounded,
          color: AppColors.attendanceCard,
          gradientColors: [
            AppColors.attendanceCard,
            AppColors.attendanceCard.withOpacity(0.7),
          ],
          onTap: () {
            // TODO Navigate Attendance
          },
        ),
        _ActionCard(
          title: "Payments",
          icon: Icons.payments_rounded,
          color: AppColors.paymentsCard,
          gradientColors: [
            AppColors.paymentsCard,
            AppColors.paymentsCard.withOpacity(0.7),
          ],
          onTap: () {
            // TODO Navigate Payments
          },
        ),
        _ActionCard(
          title: "Results",
          icon: Icons.bar_chart_rounded,
          color: AppColors.resultsCard,
          gradientColors: [
            AppColors.resultsCard,
            AppColors.resultsCard.withOpacity(0.7),
          ],
          onTap: () {
            // TODO Navigate Results
          },
        ),
        _ActionCard(
          title: "Profile",
          icon: Icons.person_rounded,
          color: AppColors.profileCard,
          gradientColors: [
            AppColors.profileCard,
            AppColors.profileCard.withOpacity(0.7),
          ],
          onTap: () {
            // TODO Navigate Profile
          },
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.9), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //--------------------------------
                // Icon Container with Glass Effect
                //--------------------------------
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientColors[0].withOpacity(0.15),
                        gradientColors[1].withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),

                const SizedBox(height: 12),

                //--------------------------------
                // Title
                //--------------------------------
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 4),

                //--------------------------------
                // Decorative Line
                //--------------------------------
                Container(
                  width: 24,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.3)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

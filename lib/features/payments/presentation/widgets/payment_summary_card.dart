// lib/features/payments/presentation/widgets/payment_summary_card.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';

class PaymentSummaryCard extends StatefulWidget {
  final int totalClasses;
  final int totalPayments;
  final double totalPaidAmount;
  final int totalUnpaidMonths;
  final String currentMonth;

  const PaymentSummaryCard({
    super.key,
    required this.totalClasses,
    required this.totalPayments,
    required this.totalPaidAmount,
    required this.totalUnpaidMonths,
    required this.currentMonth,
  });

  @override
  State<PaymentSummaryCard> createState() => _PaymentSummaryCardState();
}

class _PaymentSummaryCardState extends State<PaymentSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMonths = widget.totalPayments + widget.totalUnpaidMonths;
    final paidPercentage = totalMonths > 0
        ? (widget.totalPayments / totalMonths) * 100
        : 0.0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryBlue, AppColors.darkBlue],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Summary',
                        style: TextStyle(
                          fontFamily: AppFonts.heading,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        widget.currentMonth,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // ✅ Fixed: Unpaid Badge with proper sizing
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.totalUnpaidMonths > 0
                        ? AppColors.error.withOpacity(0.2)
                        : AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.totalUnpaidMonths > 0
                          ? AppColors.error.withOpacity(0.3)
                          : AppColors.success.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.totalUnpaidMonths > 0
                            ? Icons.warning
                            : Icons.check_circle,
                        color: widget.totalUnpaidMonths > 0
                            ? AppColors.error
                            : AppColors.success,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.totalUnpaidMonths > 0
                            ? '${widget.totalUnpaidMonths} Unpaid'
                            : 'All Paid',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: widget.totalUnpaidMonths > 0
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Stats Row - ✅ Fixed with Flexible
            Row(
              children: [
                _buildStatItem(
                  label: 'Total Paid',
                  value: 'Rs. ${widget.totalPaidAmount.toStringAsFixed(2)}',
                  icon: Icons.currency_rupee,
                  color: Colors.white,
                ),
                _buildDivider(),
                _buildStatItem(
                  label: 'Payments',
                  value: widget.totalPayments.toString(),
                  icon: Icons.receipt_long,
                  color: AppColors.primaryGold,
                ),
                _buildDivider(),
                _buildStatItem(
                  label: 'Classes',
                  value: widget.totalClasses.toString(),
                  icon: Icons.school,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Status',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '${paidPercentage.round()}% Paid',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 4,
                    child: Row(
                      children: [
                        Flexible(
                          flex: paidPercentage.round(),
                          child: Container(color: AppColors.success),
                        ),
                        Flexible(
                          flex: (100 - paidPercentage).round(),
                          child: Container(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.6)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

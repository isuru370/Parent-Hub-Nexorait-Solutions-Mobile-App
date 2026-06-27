import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/timezone_service.dart';
import '../../../data/model/payment_model.dart';

class PaymentSection extends StatelessWidget {
  final List<PaymentModel> payments;

  const PaymentSection({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    // Calculate summary
    final totalAmount = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final completedCount = payments
        .where((p) => p.status.toLowerCase() == 'completed')
        .length;
    final pendingCount = payments
        .where((p) => p.status.toLowerCase() == 'pending')
        .length;

    // Check current month
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    // Count payments for current month
    final currentMonthCount = payments.where((p) {
      return p.paymentMonth.month == currentMonth &&
          p.paymentMonth.year == currentYear;
    }).length;

    if (payments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.lightBackground],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withOpacity(0.1),
                    AppColors.primaryOrange.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.payments_outlined,
                size: 48,
                color: AppColors.primaryOrange.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No recent payments",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Your payment history is empty 💳",
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //--------------------------------
        // Summary Cards
        //--------------------------------
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Total',
                amount: totalAmount,
                color: AppColors.primaryBlue,
                icon: Icons.attach_money_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Completed',
                count: completedCount,
                color: AppColors.success,
                icon: Icons.check_circle_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Pending',
                count: pendingCount,
                color: AppColors.warning,
                icon: Icons.hourglass_empty_rounded,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        //--------------------------------
        // Current Month Card
        //--------------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue.withOpacity(0.08),
                AppColors.primaryBlue.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.darkBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_getMonthName(currentMonth)} $currentYear',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      currentMonthCount > 0
                          ? 'මෙම මාසයේ ගෙවීම් $currentMonthCount ක්'
                          : 'මෙම මාසයේ ගෙවීම් නොමැත',
                      style: TextStyle(
                        color: currentMonthCount > 0
                            ? AppColors.textSecondary
                            : AppColors.warning,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (currentMonthCount == 0) ...[
                      Text(
                        'කරුණාකර මෙම මාසයේ මුදල් ගෙවීමට කටයුතු කරන්න',
                        style: TextStyle(
                          color: AppColors.warning.withOpacity(0.8),
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: currentMonthCount > 0
                        ? [
                            AppColors.success,
                            AppColors.success.withOpacity(0.8),
                          ]
                        : [
                            AppColors.textDisabled,
                            AppColors.textDisabled.withOpacity(0.8),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentMonthCount > 0 ? '$currentMonthCount' : '0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        //--------------------------------
        // Payment List
        //--------------------------------
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: payments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final payment = payments[index];
            final isCompleted = payment.status.toLowerCase() == 'completed';
            final isPending = payment.status.toLowerCase() == 'pending';
            final isFailed = payment.status.toLowerCase() == 'failed';

            // Check if payment is for current month
            final isCurrentMonth =
                payment.paymentMonth.month == currentMonth &&
                payment.paymentMonth.year == currentYear;

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isCompleted
                      ? [AppColors.success.withOpacity(0.03), Colors.white]
                      : isPending
                      ? [AppColors.warning.withOpacity(0.05), Colors.white]
                      : isFailed
                      ? [AppColors.error.withOpacity(0.03), Colors.white]
                      : [Colors.white, Colors.white.withOpacity(0.95)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.2)
                      : isPending
                      ? AppColors.warning.withOpacity(0.2)
                      : isFailed
                      ? AppColors.error.withOpacity(0.2)
                      : AppColors.border.withOpacity(0.3),
                  width: isCompleted ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isCompleted
                        ? AppColors.success.withOpacity(0.08)
                        : isPending
                        ? AppColors.warning.withOpacity(0.08)
                        : isFailed
                        ? AppColors.error.withOpacity(0.08)
                        : Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //--------------------------------
                      // Payment Icon
                      //--------------------------------
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCompleted
                                ? [
                                    AppColors.success.withOpacity(0.15),
                                    AppColors.success.withOpacity(0.05),
                                  ]
                                : isPending
                                ? [
                                    AppColors.warning.withOpacity(0.15),
                                    AppColors.warning.withOpacity(0.05),
                                  ]
                                : isFailed
                                ? [
                                    AppColors.error.withOpacity(0.15),
                                    AppColors.error.withOpacity(0.05),
                                  ]
                                : [
                                    AppColors.primaryOrange.withOpacity(0.15),
                                    AppColors.primaryOrange.withOpacity(0.05),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCompleted
                                ? AppColors.success.withOpacity(0.2)
                                : isPending
                                ? AppColors.warning.withOpacity(0.2)
                                : isFailed
                                ? AppColors.error.withOpacity(0.2)
                                : AppColors.primaryOrange.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isCompleted
                              ? Icons.check_circle_rounded
                              : isPending
                              ? Icons.hourglass_empty_rounded
                              : isFailed
                              ? Icons.error_rounded
                              : Icons.payments_rounded,
                          color: isCompleted
                              ? AppColors.success
                              : isPending
                              ? AppColors.warning
                              : isFailed
                              ? AppColors.error
                              : AppColors.primaryOrange,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 10),

                      //--------------------------------
                      // Details
                      //--------------------------------
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Class Name with Badge
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    payment.className,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                      letterSpacing: 0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isCurrentMonth) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.primaryBlue,
                                          AppColors.darkBlue,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'CURRENT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 6,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),

                            // Collected By
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_outline_rounded,
                                  size: 10,
                                  color: AppColors.primaryBlue,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    "Collected by ${payment.collectedBy.name}",
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),

                            // Paid Date
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 10,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    "Paid: ${_formatPaymentDate(payment.paidAt)}",
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),

                            // Payment Month
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 10,
                                  color: isCurrentMonth
                                      ? AppColors.textSecondary
                                      : AppColors.error,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Month: ${_formatPaymentMonth(payment.paymentMonth)}",
                                        style: TextStyle(
                                          color: isCurrentMonth
                                              ? AppColors.textSecondary
                                              : AppColors.error,
                                          fontSize: 10,
                                          fontWeight: isCurrentMonth
                                              ? FontWeight.w400
                                              : FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (!isCurrentMonth) ...[
                                        const SizedBox(width: 3),
                                        Text(
                                          "(පසුගිය මාසය)",
                                          style: TextStyle(
                                            color: AppColors.error,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (!isCurrentMonth) ...[
                              const SizedBox(height: 1),
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    size: 10,
                                    color: AppColors.error,
                                  ),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      'මෙම මාසයේ මුදල් ගෙවීමට කාරුණික වන්න',
                                      style: TextStyle(
                                        color: AppColors.error.withOpacity(0.8),
                                        fontSize: 8,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      //--------------------------------
                      // Amount + Status
                      //--------------------------------
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Amount
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isCompleted
                                    ? [
                                        AppColors.success.withOpacity(0.1),
                                        AppColors.success.withOpacity(0.05),
                                      ]
                                    : isPending
                                    ? [
                                        AppColors.warning.withOpacity(0.1),
                                        AppColors.warning.withOpacity(0.05),
                                      ]
                                    : isFailed
                                    ? [
                                        AppColors.error.withOpacity(0.1),
                                        AppColors.error.withOpacity(0.05),
                                      ]
                                    : [
                                        AppColors.primaryOrange.withOpacity(
                                          0.1,
                                        ),
                                        AppColors.primaryOrange.withOpacity(
                                          0.05,
                                        ),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isCompleted
                                    ? AppColors.success.withOpacity(0.2)
                                    : isPending
                                    ? AppColors.warning.withOpacity(0.2)
                                    : isFailed
                                    ? AppColors.error.withOpacity(0.2)
                                    : AppColors.primaryOrange.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Rs.",
                                  style: TextStyle(
                                    color: isCompleted
                                        ? AppColors.success
                                        : isPending
                                        ? AppColors.warning
                                        : isFailed
                                        ? AppColors.error
                                        : AppColors.textPrimary,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 1),
                                Text(
                                  payment.amount.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: isCompleted
                                        ? AppColors.success
                                        : isPending
                                        ? AppColors.warning
                                        : isFailed
                                        ? AppColors.error
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Status
                          _PaymentStatusChip(status: payment.status),
                        ],
                      ),
                    ],
                  ),

                  //--------------------------------
                  // Divider at Bottom
                  //--------------------------------
                  const SizedBox(height: 10),
                  Divider(
                    color: AppColors.border.withOpacity(0.4),
                    thickness: 0.5,
                    height: 0.5,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Helper method to format payment date
  String _formatPaymentDate(DateTime dateTime) {
    try {
      return TimezoneService.formatDate(dateTime);
    } catch (e) {
      return '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
    }
  }

  // Helper method to format payment month
  String _formatPaymentMonth(DateTime dateTime) {
    try {
      return '${_getMonthName(dateTime.month)} ${dateTime.year}';
    } catch (e) {
      return '${_getMonthName(dateTime.month)} ${dateTime.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double? amount;
  final int? count;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    this.amount,
    this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 3),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            amount != null
                ? 'Rs. ${amount!.toStringAsFixed(2)}'
                : count?.toString() ?? '0',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PaymentStatusChip extends StatelessWidget {
  final String status;

  const _PaymentStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late Color bgColor;
    late String label;
    late IconData icon;

    switch (status.toLowerCase()) {
      case "completed":
        color = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.12);
        label = "Completed";
        icon = Icons.check_circle_rounded;
        break;

      case "pending":
        color = AppColors.warning;
        bgColor = AppColors.warning.withOpacity(0.12);
        label = "Pending";
        icon = Icons.hourglass_empty_rounded;
        break;

      case "failed":
        color = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.12);
        label = "Failed";
        icon = Icons.error_rounded;
        break;

      default:
        color = AppColors.info;
        bgColor = AppColors.info.withOpacity(0.12);
        label = status;
        icon = Icons.info_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 8,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

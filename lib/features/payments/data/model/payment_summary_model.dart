// lib/features/payments/data/models/payment_summary_model.dart

class PaymentSummaryModel {
  final int totalClasses;
  final int totalPayments;
  final double totalPaidAmount;
  final int totalUnpaidMonths;
  final String currentMonth;

  PaymentSummaryModel({
    required this.totalClasses,
    required this.totalPayments,
    required this.totalPaidAmount,
    required this.totalUnpaidMonths,
    required this.currentMonth,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryModel(
      totalClasses: json['total_classes'] ?? 0,
      totalPayments: json['total_payments'] ?? 0,
      totalPaidAmount: (json['total_paid_amount'] ?? 0).toDouble(),
      totalUnpaidMonths: json['total_unpaid_months'] ?? 0,
      currentMonth: json['current_month'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_classes': totalClasses,
      'total_payments': totalPayments,
      'total_paid_amount': totalPaidAmount,
      'total_unpaid_months': totalUnpaidMonths,
      'current_month': currentMonth,
    };
  }
}
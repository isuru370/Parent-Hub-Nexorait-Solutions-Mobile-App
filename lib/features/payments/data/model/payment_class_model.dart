// lib/features/payments/data/models/payment_class_model.dart

import 'payment_month_status_model.dart';
import 'payment_history_model.dart';

class PaymentClassModel {
  final int? classId;
  final String className;
  final String categoryName;
  final String? gradeName;
  final String? teacher;
  final double monthlyFee;
  final bool isCurrentMonthPaid;
  final String currentMonth;
  final int paymentCount;
  final double totalPaidAmount;
  final int unpaidMonthsCount;
  final List<String> unpaidMonths;
  final List<String> paidMonths;
  final List<String> allMonths;
  final List<PaymentMonthStatusModel> monthStatus;
  final List<PaymentHistoryModel> payments;

  PaymentClassModel({
    this.classId,
    required this.className,
    required this.categoryName,
    this.gradeName,
    this.teacher,
    required this.monthlyFee,
    required this.isCurrentMonthPaid,
    required this.currentMonth,
    required this.paymentCount,
    required this.totalPaidAmount,
    required this.unpaidMonthsCount,
    required this.unpaidMonths,
    required this.paidMonths,
    required this.allMonths,
    required this.monthStatus,
    required this.payments,
  });

  factory PaymentClassModel.fromJson(Map<String, dynamic> json) {
    return PaymentClassModel(
      classId: json['class_id'],
      className: json['class_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      gradeName: json['grade_name'],
      teacher: json['teacher'],
      monthlyFee: (json['monthly_fee'] ?? 0).toDouble(),
      isCurrentMonthPaid: json['is_current_month_paid'] ?? false,
      currentMonth: json['current_month'] ?? '',
      paymentCount: json['payment_count'] ?? 0,
      totalPaidAmount: (json['total_paid_amount'] ?? 0).toDouble(),
      unpaidMonthsCount: json['unpaid_months_count'] ?? 0,
      unpaidMonths: (json['unpaid_months'] as List? ?? []).map((e) => e.toString()).toList(),
      paidMonths: (json['paid_months'] as List? ?? []).map((e) => e.toString()).toList(),
      allMonths: (json['all_months'] as List? ?? []).map((e) => e.toString()).toList(),
      monthStatus: (json['month_status'] as List? ?? [])
          .map((e) => PaymentMonthStatusModel.fromJson(e))
          .toList(),
      payments: (json['payments'] as List? ?? [])
          .map((e) => PaymentHistoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'category_name': categoryName,
      'grade_name': gradeName,
      'teacher': teacher,
      'monthly_fee': monthlyFee,
      'is_current_month_paid': isCurrentMonthPaid,
      'current_month': currentMonth,
      'payment_count': paymentCount,
      'total_paid_amount': totalPaidAmount,
      'unpaid_months_count': unpaidMonthsCount,
      'unpaid_months': unpaidMonths,
      'paid_months': paidMonths,
      'all_months': allMonths,
      'month_status': monthStatus.map((e) => e.toJson()).toList(),
      'payments': payments.map((e) => e.toJson()).toList(),
    };
  }
}
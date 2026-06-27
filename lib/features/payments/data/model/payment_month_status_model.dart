// lib/features/payments/data/models/payment_month_status_model.dart

import 'package:flutter/material.dart';

class PaymentMonthStatusModel {
  final String month;
  final String monthName;
  final bool isPaid;
  final String status;
  final bool isCurrent;

  PaymentMonthStatusModel({
    required this.month,
    required this.monthName,
    required this.isPaid,
    required this.status,
    required this.isCurrent,
  });

  factory PaymentMonthStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentMonthStatusModel(
      month: json['month'] ?? '',
      monthName: json['month_name'] ?? '',
      isPaid: json['is_paid'] ?? false,
      status: json['status'] ?? 'unpaid',
      isCurrent: json['is_current'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'month_name': monthName,
      'is_paid': isPaid,
      'status': status,
      'is_current': isCurrent,
    };
  }

  // Helper getters
  String get shortMonthName {
    return monthName.split(' ').first.substring(0, 3);
  }

  String get year {
    return month.split('-').first;
  }

  Color get statusColor {
    if (isPaid) return Colors.green;
    return Colors.red;
  }

  IconData get statusIcon {
    if (isPaid) return Icons.check_circle;
    return Icons.cancel;
  }
}

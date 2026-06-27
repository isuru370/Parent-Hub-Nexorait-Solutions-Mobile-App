// lib/features/payments/data/models/payment_history_model.dart

class PaymentHistoryModel {
  final int paymentId;
  final String? receiptNumber;
  final String? paymentMonth;
  final String? paymentMonthName;
  final double amount;
  final double discountAmount;
  final String? paidAt;
  final String? paymentMethod;
  final String? markMethod;
  final String? status;
  final String? referenceNumber;
  final String? note;
  final CollectedByModel? collectedBy;

  PaymentHistoryModel({
    required this.paymentId,
    this.receiptNumber,
    this.paymentMonth,
    this.paymentMonthName,
    required this.amount,
    required this.discountAmount,
    this.paidAt,
    this.paymentMethod,
    this.markMethod,
    this.status,
    this.referenceNumber,
    this.note,
    this.collectedBy,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      paymentId: json['payment_id'] ?? 0,
      receiptNumber: json['receipt_number'],
      paymentMonth: json['payment_month'],
      paymentMonthName: json['payment_month_name'],
      amount: (json['amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      paidAt: json['paid_at'],
      paymentMethod: json['payment_method'],
      markMethod: json['mark_method'],
      status: json['status'],
      referenceNumber: json['reference_number'],
      note: json['note'],
      collectedBy: json['collected_by'] != null
          ? CollectedByModel.fromJson(json['collected_by'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'receipt_number': receiptNumber,
      'payment_month': paymentMonth,
      'payment_month_name': paymentMonthName,
      'amount': amount,
      'discount_amount': discountAmount,
      'paid_at': paidAt,
      'payment_method': paymentMethod,
      'mark_method': markMethod,
      'status': status,
      'reference_number': referenceNumber,
      'note': note,
      'collected_by': collectedBy?.toJson(),
    };
  }

  // Helper getters
  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  
  String get amountDisplay {
    return 'Rs. ${amount.toStringAsFixed(2)}';
  }
  
  String get paymentMethodDisplay {
    final methods = {
      'cash': 'Cash',
      'bank_transfer': 'Bank Transfer',
      'card': 'Card',
      'online': 'Online',
    };
    return methods[paymentMethod] ?? paymentMethod ?? 'N/A';
  }
}

class CollectedByModel {
  final int id;
  final String name;

  CollectedByModel({
    required this.id,
    required this.name,
  });

  factory CollectedByModel.fromJson(Map<String, dynamic> json) {
    return CollectedByModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
import 'collected_by_model.dart';

class PaymentModel {
  final int id;
  final double amount;
  final DateTime paymentMonth;
  final DateTime paidAt;
  final String markMethod;
  final String status;
  final String className;
  final CollectedByModel collectedBy;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.paymentMonth,
    required this.paidAt,
    required this.markMethod,
    required this.status,
    required this.className,
    required this.collectedBy,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json["id"],
      amount: (json["amount"] as num).toDouble(),
      paymentMonth: DateTime.parse(json["payment_month"]),
      paidAt: DateTime.parse(json["paid_at"]),
      markMethod: json["mark_method"],
      status: json["status"],
      className: json["class_name"],
      collectedBy: CollectedByModel.fromJson(json["collected_by"]),
    );
  }
}

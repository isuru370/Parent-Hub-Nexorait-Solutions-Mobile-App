// lib/features/payments/domain/repositories/payment_repository.dart

import '../../data/model/payment_response_model.dart';

abstract class PaymentRepository {
  Future<PaymentResponseModel> getPaymentHistory();
}
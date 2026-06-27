// lib/features/payments/domain/usecases/get_payment_history_usecase.dart

import '../../data/model/payment_response_model.dart';
import '../repository/payment_repository.dart';

class GetPaymentHistoryUseCase {
  final PaymentRepository repository;

  GetPaymentHistoryUseCase({required this.repository});

  Future<PaymentResponseModel> execute() async {
    return await repository.getPaymentHistory();
  }
}

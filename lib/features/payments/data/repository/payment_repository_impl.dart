// lib/features/payments/data/repositories/payment_repository_impl.dart

import '../../domain/repository/payment_repository.dart';
import '../datasource/payment_remote_datasource.dart';
import '../model/payment_response_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<PaymentResponseModel> getPaymentHistory() {
    return remoteDataSource.getPaymentHistory();
  }
}
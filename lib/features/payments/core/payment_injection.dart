// lib/features/payments/core/payment_injection.dart

import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/payment_remote_datasource.dart';
import '../data/repository/payment_repository_impl.dart';
import '../domain/repository/payment_repository.dart';
import '../domain/usecase/get_payment_history_usecase.dart';
import '../presentation/bloc/payment/payment_bloc.dart';

Future<void> initPaymentDI() async {
  /// DataSource
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl<PaymentRemoteDataSource>()),
  );

  /// UseCase
  sl.registerLazySingleton(
    () => GetPaymentHistoryUseCase(repository: sl<PaymentRepository>()),
  );

  /// Bloc
  sl.registerFactory(
    () => PaymentBloc(
      getPaymentHistoryUseCase: sl<GetPaymentHistoryUseCase>(),
    ),
  );
}
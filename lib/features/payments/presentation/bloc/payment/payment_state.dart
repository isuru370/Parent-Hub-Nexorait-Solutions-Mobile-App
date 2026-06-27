// lib/features/payments/presentation/bloc/payment_state.dart

part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

/// Initial state
final class PaymentInitial extends PaymentState {}

/// Loading state
final class PaymentLoading extends PaymentState {}

/// Loaded state with data
final class PaymentLoaded extends PaymentState {
  final PaymentResponseModel data;
  final List<PaymentClassModel> filteredClasses;
  final String? selectedFilter;

  const PaymentLoaded({
    required this.data,
    this.filteredClasses = const [],
    this.selectedFilter,
  });

  @override
  List<Object> get props => [data, filteredClasses, selectedFilter ?? ''];

  /// Get all classes
  List<PaymentClassModel> get allClasses => data.data.classes;

  /// Get filtered classes (or all if no filter)
  List<PaymentClassModel> get classes {
    return filteredClasses.isEmpty ? allClasses : filteredClasses;
  }

  /// Get summary
  PaymentSummaryModel get summary => data.data.summary;
}

/// Error state
final class PaymentError extends PaymentState {
  final String message;
  final int? statusCode;

  const PaymentError({required this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

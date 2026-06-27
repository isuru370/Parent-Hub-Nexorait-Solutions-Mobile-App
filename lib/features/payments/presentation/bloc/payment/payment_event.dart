// lib/features/payments/presentation/bloc/payment_event.dart

part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

/// Get payment history event
final class GetPaymentHistoryEvent extends PaymentEvent {}

/// Refresh payment history event
final class RefreshPaymentHistoryEvent extends PaymentEvent {}

/// Filter payments by class
final class FilterPaymentsByClassEvent extends PaymentEvent {
  final int? classId;

  const FilterPaymentsByClassEvent({this.classId});

  @override
  List<Object> get props => [classId ?? 0];
}

/// Filter payments by month
final class FilterPaymentsByMonthEvent extends PaymentEvent {
  final String? month;

  const FilterPaymentsByMonthEvent({this.month});

  @override
  List<Object> get props => [month ?? ''];
}
// lib/features/payments/presentation/bloc/payment_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/payment_class_model.dart';
import '../../../data/model/payment_response_model.dart';
import '../../../data/model/payment_summary_model.dart';
import '../../../domain/usecase/get_payment_history_usecase.dart';



part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetPaymentHistoryUseCase getPaymentHistoryUseCase;

  PaymentBloc({
    required this.getPaymentHistoryUseCase,
  }) : super(PaymentInitial()) {
    // Register event handlers
    on<GetPaymentHistoryEvent>(_onGetPaymentHistory);
    on<RefreshPaymentHistoryEvent>(_onRefreshPaymentHistory);
    on<FilterPaymentsByClassEvent>(_onFilterByClass);
    on<FilterPaymentsByMonthEvent>(_onFilterByMonth);
  }

  /// Handle GetPaymentHistoryEvent
  Future<void> _onGetPaymentHistory(
    GetPaymentHistoryEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final data = await getPaymentHistoryUseCase.execute();
      emit(PaymentLoaded(
        data: data,
        filteredClasses: data.data.classes,
      ));
    } catch (e) {
      emit(PaymentError(
        message: _getErrorMessage(e),
      ));
    }
  }

  /// Handle RefreshPaymentHistoryEvent
  Future<void> _onRefreshPaymentHistory(
    RefreshPaymentHistoryEvent event,
    Emitter<PaymentState> emit,
  ) async {
    // Only emit loading if not already loading
    if (state is! PaymentLoading) {
      emit(PaymentLoading());
    }

    try {
      final data = await getPaymentHistoryUseCase.execute();
      
      // Preserve existing filters if any
      String? currentFilter;
      if (state is PaymentLoaded) {
        currentFilter = (state as PaymentLoaded).selectedFilter;
      }

      final filtered = _applyFilter(data.data.classes, currentFilter);
      
      emit(PaymentLoaded(
        data: data,
        filteredClasses: filtered,
        selectedFilter: currentFilter,
      ));
    } catch (e) {
      emit(PaymentError(
        message: _getErrorMessage(e),
      ));
    }
  }

  /// Handle FilterPaymentsByClassEvent
  void _onFilterByClass(
    FilterPaymentsByClassEvent event,
    Emitter<PaymentState> emit,
  ) {
    if (state is! PaymentLoaded) return;

    final currentState = state as PaymentLoaded;
    final allClasses = currentState.allClasses;

    List<PaymentClassModel> filtered;
    String? filterLabel;

    if (event.classId != null) {
      filtered = allClasses.where((c) => c.classId == event.classId).toList();
      filterLabel = 'Class ${event.classId}';
    } else {
      filtered = allClasses;
      filterLabel = null;
    }

    emit(PaymentLoaded(
      data: currentState.data,
      filteredClasses: filtered,
      selectedFilter: filterLabel,
    ));
  }

  /// Handle FilterPaymentsByMonthEvent
  void _onFilterByMonth(
    FilterPaymentsByMonthEvent event,
    Emitter<PaymentState> emit,
  ) {
    if (state is! PaymentLoaded) return;

    final currentState = state as PaymentLoaded;
    final allClasses = currentState.allClasses;

    List<PaymentClassModel> filtered;
    String? filterLabel;

    if (event.month != null && event.month!.isNotEmpty) {
      filtered = allClasses.where((c) {
        return c.monthStatus.any((m) => m.month == event.month);
      }).toList();
      filterLabel = 'Month ${event.month}';
    } else {
      filtered = allClasses;
      filterLabel = null;
    }

    emit(PaymentLoaded(
      data: currentState.data,
      filteredClasses: filtered,
      selectedFilter: filterLabel,
    ));
  }

  /// Helper: Get error message
  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Failed to load payment history. Please try again.';
  }

  /// Helper: Apply filter
  List<PaymentClassModel> _applyFilter(
    List<PaymentClassModel> classes,
    String? filter,
  ) {
    if (filter == null) return classes;

    if (filter.startsWith('Class ')) {
      final classId = int.tryParse(filter.replaceAll('Class ', ''));
      if (classId != null) {
        return classes.where((c) => c.classId == classId).toList();
      }
    }

    if (filter.startsWith('Month ')) {
      final month = filter.replaceAll('Month ', '');
      return classes.where((c) {
        return c.monthStatus.any((m) => m.month == month);
      }).toList();
    }

    return classes;
  }
}
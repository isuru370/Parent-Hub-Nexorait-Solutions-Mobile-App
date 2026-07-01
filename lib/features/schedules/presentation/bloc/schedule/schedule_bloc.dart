// lib/features/schedules/presentation/bloc/schedule_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/schedule_model.dart';
import '../../../data/model/schedule_response_model.dart';
import '../../../domain/usecase/get_schedules_usecase.dart';


part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetSchedulesUseCase getSchedulesUseCase;

  ScheduleBloc({
    required this.getSchedulesUseCase,
  }) : super(ScheduleInitial()) {
    on<GetSchedulesEvent>(_onGetSchedules);
    on<RefreshSchedulesEvent>(_onRefreshSchedules);
    on<FilterSchedulesByClassEvent>(_onFilterByClass);
    on<FilterSchedulesByStatusEvent>(_onFilterByStatus);
  }

  Future<void> _onGetSchedules(
    GetSchedulesEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());

    try {
      final data = await getSchedulesUseCase.execute();
      emit(ScheduleLoaded(
        data: data,
        filteredSchedules: data.data,
      ));
    } catch (e) {
      emit(ScheduleError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshSchedules(
    RefreshSchedulesEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state is! ScheduleLoading) {
      emit(ScheduleLoading());
    }

    try {
      final data = await getSchedulesUseCase.execute();

      String? classFilter;
      String? statusFilter;
      if (state is ScheduleLoaded) {
        classFilter = (state as ScheduleLoaded).selectedClassFilter;
        statusFilter = (state as ScheduleLoaded).selectedStatusFilter;
      }

      final filtered = _applyFilters(data.data, classFilter, statusFilter);

      emit(ScheduleLoaded(
        data: data,
        filteredSchedules: filtered,
        selectedClassFilter: classFilter,
        selectedStatusFilter: statusFilter,
      ));
    } catch (e) {
      emit(ScheduleError(message: _getErrorMessage(e)));
    }
  }

  void _onFilterByClass(
    FilterSchedulesByClassEvent event,
    Emitter<ScheduleState> emit,
  ) {
    if (state is! ScheduleLoaded) return;

    final currentState = state as ScheduleLoaded;
    final filtered = _applyFilters(
      currentState.data.data,
      event.className,
      currentState.selectedStatusFilter,
    );

    emit(ScheduleLoaded(
      data: currentState.data,
      filteredSchedules: filtered,
      selectedClassFilter: event.className,
      selectedStatusFilter: currentState.selectedStatusFilter,
    ));
  }

  void _onFilterByStatus(
    FilterSchedulesByStatusEvent event,
    Emitter<ScheduleState> emit,
  ) {
    if (state is! ScheduleLoaded) return;

    final currentState = state as ScheduleLoaded;
    final filtered = _applyFilters(
      currentState.data.data,
      currentState.selectedClassFilter,
      event.status,
    );

    emit(ScheduleLoaded(
      data: currentState.data,
      filteredSchedules: filtered,
      selectedClassFilter: currentState.selectedClassFilter,
      selectedStatusFilter: event.status,
    ));
  }

  List<ScheduleModel> _applyFilters(
    List<ScheduleModel> schedules,
    String? className,
    String? status,
  ) {
    List<ScheduleModel> result = schedules;

    // Filter by class
    if (className != null && className.isNotEmpty) {
      result = result.where((s) {
        return s.studentClass?.className == className;
      }).toList();
    }

    // Filter by status
    if (status != null && status.isNotEmpty) {
      result = result.where((s) => s.status == status).toList();
    }

    return result;
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Failed to load schedules. Please try again.';
  }
}
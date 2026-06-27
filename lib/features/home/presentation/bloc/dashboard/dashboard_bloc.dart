import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/dashboard_data_model.dart';
import '../../../domain/usecase/get_dashboard_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDashboardUseCase;

  DashboardBloc({
    required this.getDashboardUseCase,
  }) : super(const DashboardInitial()) {

    on<LoadDashboardEvent>(_loadDashboard);

    on<RefreshDashboardEvent>(_refreshDashboard);
  }

  Future<void> _loadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    try {
      final response = await getDashboardUseCase();

      if (response.status) {
        emit(DashboardLoaded(response.data));
      } else {
        emit(DashboardError(response.message));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _refreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final response = await getDashboardUseCase();

      if (response.status) {
        emit(DashboardLoaded(response.data));
      } else {
        emit(DashboardError(response.message));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
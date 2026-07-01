// lib/features/schedules/presentation/bloc/schedule_state.dart

part of 'schedule_bloc.dart';

sealed class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleLoading extends ScheduleState {}

final class ScheduleLoaded extends ScheduleState {
  final ScheduleResponseModel data;
  final List<ScheduleModel> filteredSchedules;
  final String? selectedClassFilter;
  final String? selectedStatusFilter;

  const ScheduleLoaded({
    required this.data,
    this.filteredSchedules = const [],
    this.selectedClassFilter,
    this.selectedStatusFilter,
  });

  @override
  List<Object> get props => [
    data,
    filteredSchedules,
    selectedClassFilter ?? '',
    selectedStatusFilter ?? '',
  ];

  List<ScheduleModel> get schedules {
    return filteredSchedules.isEmpty ? data.data : filteredSchedules;
  }

  Map<String, List<ScheduleModel>> get groupedByClass {
    final map = <String, List<ScheduleModel>>{};
    for (final schedule in schedules) {
      final className = schedule.studentClass?.className ?? 'Unknown';
      if (!map.containsKey(className)) {
        map[className] = [];
      }
      map[className]!.add(schedule);
    }
    return map;
  }

  List<String> get uniqueClasses {
    final classes = <String>{};
    for (final schedule in data.data) {
      if (schedule.studentClass?.className != null) {
        classes.add(schedule.studentClass!.className);
      }
    }
    return classes.toList()..sort();
  }

  int get totalSchedules => schedules.length;
}

final class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError({required this.message});

  @override
  List<Object> get props => [message];
}
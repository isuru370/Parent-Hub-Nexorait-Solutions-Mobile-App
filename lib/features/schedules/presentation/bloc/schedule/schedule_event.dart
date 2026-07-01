// lib/features/schedules/presentation/bloc/schedule_event.dart

part of 'schedule_bloc.dart';

sealed class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class GetSchedulesEvent extends ScheduleEvent {}

class RefreshSchedulesEvent extends ScheduleEvent {}

class FilterSchedulesByClassEvent extends ScheduleEvent {
  final String? className;

  const FilterSchedulesByClassEvent({this.className});

  @override
  List<Object> get props => [className ?? ''];
}

class FilterSchedulesByStatusEvent extends ScheduleEvent {
  final String? status;

  const FilterSchedulesByStatusEvent({this.status});

  @override
  List<Object> get props => [status ?? ''];
}
// lib/features/teachers/presentation/bloc/teacher_event.dart

part of 'teacher_bloc.dart';

sealed class TeacherEvent extends Equatable {
  const TeacherEvent();

  @override
  List<Object> get props => [];
}

class GetTeachersEvent extends TeacherEvent {}

class RefreshTeachersEvent extends TeacherEvent {}

class FilterTeachersByClassEvent extends TeacherEvent {
  final String? className;

  const FilterTeachersByClassEvent({this.className});

  @override
  List<Object> get props => [className ?? ''];
}

class FilterTeachersByGradeEvent extends TeacherEvent {
  final int? gradeId;

  const FilterTeachersByGradeEvent({this.gradeId});

  @override
  List<Object> get props => [gradeId ?? 0];
}

class SearchTeachersEvent extends TeacherEvent {
  final String query;

  const SearchTeachersEvent({required this.query});

  @override
  List<Object> get props => [query];
}
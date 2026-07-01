// lib/features/exams/presentation/bloc/exam_event.dart

part of 'exam_bloc.dart';

sealed class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object> get props => [];
}

class GetExamListEvent extends ExamEvent {}

class RefreshExamListEvent extends ExamEvent {}

class FilterExamsByClassEvent extends ExamEvent {
  final int? classId;

  const FilterExamsByClassEvent({this.classId});

  @override
  List<Object> get props => [classId ?? 0];
}

class FilterExamsByStatusEvent extends ExamEvent {
  final String? status;

  const FilterExamsByStatusEvent({this.status});

  @override
  List<Object> get props => [status ?? ''];
}
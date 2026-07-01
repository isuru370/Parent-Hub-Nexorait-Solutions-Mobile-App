// lib/features/exams/presentation/bloc/exam_state.dart

part of 'exam_bloc.dart';

sealed class ExamState extends Equatable {
  const ExamState();

  @override
  List<Object> get props => [];
}

final class ExamInitial extends ExamState {}

final class ExamLoading extends ExamState {}

final class ExamLoaded extends ExamState {
  final ExamResponseModel data;
  final List<ExamClassModel> filteredClasses;
  final String? selectedClassFilter;
  final String? selectedStatusFilter;

  const ExamLoaded({
    required this.data,
    this.filteredClasses = const [],
    this.selectedClassFilter,
    this.selectedStatusFilter,
  });

  @override
  List<Object> get props => [
        data,
        filteredClasses,
        selectedClassFilter ?? '',
        selectedStatusFilter ?? '',
      ];

  List<ExamClassModel> get allClasses => data.data.classes;

  List<ExamClassModel> get classes {
    return filteredClasses.isEmpty ? allClasses : filteredClasses;
  }

  ExamSummaryModel get summary => data.data.summary;
}

final class ExamError extends ExamState {
  final String message;

  const ExamError({required this.message});

  @override
  List<Object> get props => [message];
}
// lib/features/teachers/presentation/bloc/teacher_state.dart

part of 'teacher_bloc.dart';

sealed class TeacherState extends Equatable {
  const TeacherState();

  @override
  List<Object> get props => [];
}

final class TeacherInitial extends TeacherState {}

final class TeacherLoading extends TeacherState {}

final class TeacherLoaded extends TeacherState {
  final List<TeacherModel> teachers;
  final List<TeacherModel> filteredTeachers;
  final String? searchQuery;
  final String? selectedClassFilter;
  final int? selectedGradeFilter;

  const TeacherLoaded({
    required this.teachers,
    this.filteredTeachers = const [],
    this.searchQuery,
    this.selectedClassFilter,
    this.selectedGradeFilter,
  });

  @override
  List<Object> get props => [
        teachers,
        filteredTeachers,
        searchQuery ?? '',
        selectedClassFilter ?? '',
        selectedGradeFilter ?? 0,
      ];

  List<TeacherModel> get displayTeachers {
    return filteredTeachers.isEmpty ? teachers : filteredTeachers;
  }

  int get totalTeachers => displayTeachers.length;
}

final class TeacherError extends TeacherState {
  final String message;

  const TeacherError({required this.message});

  @override
  List<Object> get props => [message];
}
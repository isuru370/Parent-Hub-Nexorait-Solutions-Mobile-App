// lib/features/teachers/presentation/bloc/teacher_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/teacher_model.dart';
import '../../../domain/usecase/get_teachers_usecase.dart';

part 'teacher_event.dart';
part 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final GetTeachersUseCase getTeachersUseCase;

  TeacherBloc({required this.getTeachersUseCase}) : super(TeacherInitial()) {
    on<GetTeachersEvent>(_onGetTeachers);
    on<RefreshTeachersEvent>(_onRefreshTeachers);
    on<FilterTeachersByClassEvent>(_onFilterByClass);
    on<FilterTeachersByGradeEvent>(_onFilterByGrade);
    on<SearchTeachersEvent>(_onSearchTeachers);
  }

  Future<void> _onGetTeachers(
    GetTeachersEvent event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());

    try {
      final response = await getTeachersUseCase.execute();
      if (response.success) {
        emit(
          TeacherLoaded(
            teachers: response.data,
            filteredTeachers: response.data,
          ),
        );
      } else {
        emit(TeacherError(message: response.message));
      }
    } catch (e) {
      emit(TeacherError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshTeachers(
    RefreshTeachersEvent event,
    Emitter<TeacherState> emit,
  ) async {
    if (state is! TeacherLoading) {
      emit(TeacherLoading());
    }

    try {
      final response = await getTeachersUseCase.execute();
      if (response.success) {
        final currentState = state is TeacherLoaded
            ? state as TeacherLoaded
            : null;
        emit(
          TeacherLoaded(
            teachers: response.data,
            filteredTeachers: response.data,
            searchQuery: currentState?.searchQuery,
            selectedClassFilter: currentState?.selectedClassFilter,
            selectedGradeFilter: currentState?.selectedGradeFilter,
          ),
        );
      } else {
        emit(TeacherError(message: response.message));
      }
    } catch (e) {
      emit(TeacherError(message: _getErrorMessage(e)));
    }
  }

  void _onFilterByClass(
    FilterTeachersByClassEvent event,
    Emitter<TeacherState> emit,
  ) {
    if (state is! TeacherLoaded) return;

    final currentState = state as TeacherLoaded;

    // ✅ Fixed: Pass teachers parameter correctly
    final filtered = _applyFilters(
      teachers: currentState.teachers,
      className: event.className,
      gradeId: currentState.selectedGradeFilter,
      searchQuery: currentState.searchQuery,
    );

    emit(
      TeacherLoaded(
        teachers: currentState.teachers,
        filteredTeachers: filtered,
        searchQuery: currentState.searchQuery,
        selectedClassFilter: event.className,
        selectedGradeFilter: currentState.selectedGradeFilter,
      ),
    );
  }

  void _onFilterByGrade(
    FilterTeachersByGradeEvent event,
    Emitter<TeacherState> emit,
  ) {
    if (state is! TeacherLoaded) return;

    final currentState = state as TeacherLoaded;

    // ✅ Fixed: Pass teachers parameter correctly
    final filtered = _applyFilters(
      teachers: currentState.teachers,
      className: currentState.selectedClassFilter,
      gradeId: event.gradeId,
      searchQuery: currentState.searchQuery,
    );

    emit(
      TeacherLoaded(
        teachers: currentState.teachers,
        filteredTeachers: filtered,
        searchQuery: currentState.searchQuery,
        selectedClassFilter: currentState.selectedClassFilter,
        selectedGradeFilter: event.gradeId,
      ),
    );
  }

  void _onSearchTeachers(
    SearchTeachersEvent event,
    Emitter<TeacherState> emit,
  ) {
    if (state is! TeacherLoaded) return;

    final currentState = state as TeacherLoaded;

    // ✅ Fixed: Pass teachers parameter correctly
    final filtered = _applyFilters(
      teachers: currentState.teachers,
      className: currentState.selectedClassFilter,
      gradeId: currentState.selectedGradeFilter,
      searchQuery: event.query.isNotEmpty ? event.query : null,
    );

    emit(
      TeacherLoaded(
        teachers: currentState.teachers,
        filteredTeachers: filtered,
        searchQuery: event.query.isNotEmpty ? event.query : null,
        selectedClassFilter: currentState.selectedClassFilter,
        selectedGradeFilter: currentState.selectedGradeFilter,
      ),
    );
  }

  // ✅ Fixed: _applyFilters method with correct parameter order
  List<TeacherModel> _applyFilters({
    required List<TeacherModel> teachers,
    String? className,
    int? gradeId,
    String? searchQuery,
  }) {
    List<TeacherModel> result = teachers;

    // Filter by class name
    if (className != null && className.isNotEmpty) {
      result = result.where((teacher) {
        return teacher.classes.any((c) => c.className == className);
      }).toList();
    }

    // Filter by grade
    if (gradeId != null && gradeId > 0) {
      result = result.where((teacher) {
        return teacher.classes.any((c) => c.gradeId == gradeId);
      }).toList();
    }

    // Search by name or initials
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((teacher) {
        return teacher.fullName.toLowerCase().contains(query) ||
            teacher.initials.toLowerCase().contains(query) ||
            teacher.email.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Failed to load teachers. Please try again.';
  }
}

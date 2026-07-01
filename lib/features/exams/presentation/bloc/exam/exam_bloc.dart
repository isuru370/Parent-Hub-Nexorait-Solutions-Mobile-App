// lib/features/exams/presentation/bloc/exam_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/exam_class_model.dart';
import '../../../data/model/exam_response_model.dart';
import '../../../data/model/exam_summary_model.dart';
import '../../../domain/usecase/get_exam_list_usecase.dart';


part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final GetExamListUseCase getExamListUseCase;

  ExamBloc({
    required this.getExamListUseCase,
  }) : super(ExamInitial()) {
    on<GetExamListEvent>(_onGetExamList);
    on<RefreshExamListEvent>(_onRefreshExamList);
    on<FilterExamsByClassEvent>(_onFilterByClass);
    on<FilterExamsByStatusEvent>(_onFilterByStatus);
  }

  Future<void> _onGetExamList(
    GetExamListEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(ExamLoading());

    try {
      final data = await getExamListUseCase.execute();
      emit(ExamLoaded(
        data: data,
        filteredClasses: data.data.classes,
      ));
    } catch (e) {
      emit(ExamError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshExamList(
    RefreshExamListEvent event,
    Emitter<ExamState> emit,
  ) async {
    if (state is! ExamLoading) {
      emit(ExamLoading());
    }

    try {
      final data = await getExamListUseCase.execute();

      String? classFilter;
      String? statusFilter;
      if (state is ExamLoaded) {
        classFilter = (state as ExamLoaded).selectedClassFilter;
        statusFilter = (state as ExamLoaded).selectedStatusFilter;
      }

      final filtered = _applyFilters(data.data.classes, classFilter, statusFilter);

      emit(ExamLoaded(
        data: data,
        filteredClasses: filtered,
        selectedClassFilter: classFilter,
        selectedStatusFilter: statusFilter,
      ));
    } catch (e) {
      emit(ExamError(message: _getErrorMessage(e)));
    }
  }

  void _onFilterByClass(
    FilterExamsByClassEvent event,
    Emitter<ExamState> emit,
  ) {
    if (state is! ExamLoaded) return;

    final currentState = state as ExamLoaded;
    final allClasses = currentState.allClasses;

    final filtered = _applyFilters(
      allClasses,
      event.classId?.toString(),
      currentState.selectedStatusFilter,
    );

    emit(ExamLoaded(
      data: currentState.data,
      filteredClasses: filtered,
      selectedClassFilter: event.classId?.toString(),
      selectedStatusFilter: currentState.selectedStatusFilter,
    ));
  }

  void _onFilterByStatus(
    FilterExamsByStatusEvent event,
    Emitter<ExamState> emit,
  ) {
    if (state is! ExamLoaded) return;

    final currentState = state as ExamLoaded;
    final allClasses = currentState.allClasses;

    final filtered = _applyFilters(
      allClasses,
      currentState.selectedClassFilter,
      event.status,
    );

    emit(ExamLoaded(
      data: currentState.data,
      filteredClasses: filtered,
      selectedClassFilter: currentState.selectedClassFilter,
      selectedStatusFilter: event.status,
    ));
  }

  List<ExamClassModel> _applyFilters(
    List<ExamClassModel> classes,
    String? classFilter,
    String? statusFilter,
  ) {
    List<ExamClassModel> result = classes;

    // Filter by class
    if (classFilter != null) {
      final classId = int.tryParse(classFilter);
      if (classId != null) {
        result = result.where((c) => c.classId == classId).toList();
      }
    }

    // Filter by status
    if (statusFilter != null && statusFilter.isNotEmpty) {
      result = result.map((classItem) {
        final filteredExams = classItem.exams
            .where((exam) => exam.status == statusFilter)
            .toList();
        return ExamClassModel(
          classId: classItem.classId,
          className: classItem.className,
          subjectName: classItem.subjectName,
          teacher: classItem.teacher,
          examCount: filteredExams.length,
          exams: filteredExams,
        );
      }).where((c) => c.exams.isNotEmpty).toList();
    }

    return result;
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Failed to load exams. Please try again.';
  }
}
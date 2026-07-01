// lib/features/results/presentation/bloc/result_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/storage/storage_keys.dart';
import '../../../../../core/storage/storage_service.dart';
import '../../../data/model/result_request_model.dart';
import '../../../data/model/result_response_model.dart';
import '../../../domain/usecase/get_result_usecase.dart';

part 'result_event.dart';
part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final GetResultUseCase getResultUseCase;

  ResultBloc({required this.getResultUseCase}) : super(ResultInitial()) {
    on<GetResultEvent>(_onGetResult);
    on<ClearResultEvent>(_onClearResult);
  }

  Future<void> _onGetResult(
    GetResultEvent event,
    Emitter<ResultState> emit,
  ) async {
    emit(ResultLoading());

    try {
      final student = StorageService.getJson(StorageKeys.student);
      if (student == null) {
        emit(const ResultError(message: 'Student data not found'));
        return;
      }

      final studentId = student['student_id'];
      if (studentId == null) {
        emit(const ResultError(message: 'Student ID not found'));
        return;
      }

      final request = ResultRequestModel(
        studentId: studentId,
        examId: event.examId,
      );

      final response = await getResultUseCase.execute(request);

      // ✅ Check if response has data
      if (response.status && response.data != null) {
        emit(ResultLoaded(data: response.data!));
      } else {
        emit(ResultNotPublished(message: response.message));
      }
    } catch (e) {
      emit(ResultError(message: _getErrorMessage(e)));
    }
  }

  void _onClearResult(ClearResultEvent event, Emitter<ResultState> emit) {
    // ✅ Only emit if not already disposed
    if (!isClosed) {
      emit(ResultInitial());
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Failed to load result. Please try again.';
  }
}

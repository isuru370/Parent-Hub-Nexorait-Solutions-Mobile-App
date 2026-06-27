import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/attendance_response_model.dart';
import '../../../domain/usecase/get_student_attendance_usecase.dart';


part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc
    extends Bloc<AttendanceEvent, AttendanceState> {

  final GetAttendanceUseCase getAttendanceUseCase;

  AttendanceBloc({
    required this.getAttendanceUseCase,
  }) : super(AttendanceInitial()) {

    on<GetAttendanceEvent>(_getAttendance);
  }

  Future<void> _getAttendance(
    GetAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {

    emit(AttendanceLoading());

    try {

      final response =
          await getAttendanceUseCase();

      if (response.status) {

        emit(
          AttendanceLoaded(response),
        );

      } else {

        emit(
          AttendanceError(
            response.message,
          ),
        );
      }

    } catch (e) {

      emit(
        AttendanceError(
          e.toString(),
        ),
      );
    }
  }
}
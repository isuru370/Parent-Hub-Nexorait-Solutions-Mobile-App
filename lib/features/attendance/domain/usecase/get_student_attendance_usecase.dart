import '../../data/model/attendance_response_model.dart';
import '../repository/attendance_repository.dart';

class GetAttendanceUseCase {
  final AttendanceRepository repository;

  GetAttendanceUseCase({
    required this.repository,
  });

  Future<AttendanceResponseModel> call() {
    return repository.getAttendance();
  }
}
import '../../data/model/attendance_response_model.dart';

abstract class AttendanceRepository {
  Future<AttendanceResponseModel> getAttendance();
}
import '../../domain/repository/attendance_repository.dart';
import '../datasource/attendance_remote_datasource.dart';
import '../model/attendance_response_model.dart';

class AttendanceRepositoryImpl
    implements AttendanceRepository {

  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<AttendanceResponseModel> getAttendance() {
    return remoteDataSource.getAttendance();
  }
}
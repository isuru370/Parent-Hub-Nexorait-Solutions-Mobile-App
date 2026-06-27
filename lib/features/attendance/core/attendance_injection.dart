import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/attendance_remote_datasource.dart';
import '../data/repository/attendance_repository_impl.dart';
import '../domain/repository/attendance_repository.dart';
import '../domain/usecase/get_student_attendance_usecase.dart';
import '../presentation/bloc/attendance/attendance_bloc.dart';

Future<void> initAttendanceDI() async {
  /// DataSource
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      remoteDataSource: sl<AttendanceRemoteDataSource>(),
    ),
  );

  /// UseCase
  sl.registerLazySingleton(() => GetAttendanceUseCase(repository: sl()));

  /// Bloc
  sl.registerFactory(
    () => AttendanceBloc(getAttendanceUseCase: sl<GetAttendanceUseCase>()),
  );
}

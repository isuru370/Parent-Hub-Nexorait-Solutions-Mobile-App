// lib/features/teachers/core/teacher_injection.dart

import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/teacher_remote_datasource.dart';
import '../data/repository/teacher_repository_impl.dart';
import '../domain/repository/teacher_repository.dart';
import '../domain/usecase/get_teachers_usecase.dart';
import '../presentation/bloc/teacher/teacher_bloc.dart';

Future<void> initTeacherDI() async {
  /// DataSource
  sl.registerLazySingleton<TeacherRemoteDataSource>(
    () => TeacherRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<TeacherRepository>(
    () => TeacherRepositoryImpl(remoteDataSource: sl<TeacherRemoteDataSource>()),
  );

  /// UseCase
  sl.registerLazySingleton(
    () => GetTeachersUseCase(repository: sl<TeacherRepository>()),
  );

  /// Bloc
  sl.registerFactory(
    () => TeacherBloc(
      getTeachersUseCase: sl<GetTeachersUseCase>(),
    ),
  );
}
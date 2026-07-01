// lib/features/teachers/data/repositories/teacher_repository_impl.dart

import '../../domain/repository/teacher_repository.dart';
import '../datasource/teacher_remote_datasource.dart';
import '../model/teacher_response_model.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;

  TeacherRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<TeacherResponseModel> getTeachers() {
    return remoteDataSource.getTeachers();
  }
}
// lib/features/exams/data/repositories/exam_repository_impl.dart

import '../../domain/repository/exam_repository.dart';
import '../datasource/exam_remote_datasource.dart';
import '../model/exam_response_model.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamRemoteDataSource remoteDataSource;

  ExamRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<ExamResponseModel> getExamList() {
    return remoteDataSource.getExamList();
  }
}
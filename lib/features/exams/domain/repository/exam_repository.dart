// lib/features/exams/domain/repositories/exam_repository.dart

import '../../data/model/exam_response_model.dart';

abstract class ExamRepository {
  Future<ExamResponseModel> getExamList();
}
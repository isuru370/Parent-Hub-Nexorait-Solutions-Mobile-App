// lib/features/exams/domain/usecases/get_exam_list_usecase.dart


import '../../data/model/exam_response_model.dart';
import '../repository/exam_repository.dart';

class GetExamListUseCase {
  final ExamRepository repository;

  GetExamListUseCase({required this.repository});

  Future<ExamResponseModel> execute() async {
    return await repository.getExamList();
  }
}
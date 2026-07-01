// lib/features/results/domain/usecases/get_result_usecase.dart


import '../../data/model/result_request_model.dart';
import '../../data/model/result_response_model.dart';
import '../repository/result_repository.dart';

class GetResultUseCase {
  final ResultRepository repository;

  GetResultUseCase({required this.repository});

  Future<ResultResponseModel> execute(ResultRequestModel request) async {
    return await repository.getResult(request);
  }
}
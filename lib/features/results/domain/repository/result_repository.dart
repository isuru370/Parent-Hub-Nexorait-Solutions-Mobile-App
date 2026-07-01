// lib/features/results/domain/repositories/result_repository.dart



import '../../data/model/result_request_model.dart';
import '../../data/model/result_response_model.dart';

abstract class ResultRepository {
  Future<ResultResponseModel> getResult(ResultRequestModel request);
}
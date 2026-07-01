// lib/features/results/data/repositories/result_repository_impl.dart



import '../../domain/repository/result_repository.dart';
import '../datasource/result_remote_datasource.dart';
import '../model/result_request_model.dart';
import '../model/result_response_model.dart';

class ResultRepositoryImpl implements ResultRepository {
  final ResultRemoteDataSource remoteDataSource;

  ResultRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<ResultResponseModel> getResult(ResultRequestModel request) {
    return remoteDataSource.getResult(request);
  }
}
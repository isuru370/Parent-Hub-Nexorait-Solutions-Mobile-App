// lib/features/schedules/data/repositories/schedule_repository_impl.dart


import '../../domain/repository/schedule_repository.dart';
import '../datasource/schedule_remote_datasource.dart';
import '../model/schedule_response_model.dart';


class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<ScheduleResponseModel> getSchedules() {
    return remoteDataSource.getSchedules();
  }
}
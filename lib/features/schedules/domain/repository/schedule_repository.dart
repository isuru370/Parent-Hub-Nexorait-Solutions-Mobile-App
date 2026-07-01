// lib/features/schedules/domain/repositories/schedule_repository.dart


import '../../data/model/schedule_response_model.dart';

abstract class ScheduleRepository {
  Future<ScheduleResponseModel> getSchedules();
}
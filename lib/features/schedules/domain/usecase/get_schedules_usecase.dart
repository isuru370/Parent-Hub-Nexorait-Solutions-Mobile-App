// lib/features/schedules/domain/usecases/get_schedules_usecase.dart

import '../../data/model/schedule_response_model.dart';
import '../repository/schedule_repository.dart';

class GetSchedulesUseCase {
  final ScheduleRepository repository;

  GetSchedulesUseCase({required this.repository});

  Future<ScheduleResponseModel> execute() async {
    return await repository.getSchedules();
  }
}
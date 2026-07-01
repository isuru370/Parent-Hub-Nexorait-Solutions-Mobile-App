// lib/features/teachers/domain/repositories/teacher_repository.dart

import '../../data/model/teacher_response_model.dart';

abstract class TeacherRepository {
  Future<TeacherResponseModel> getTeachers();
}
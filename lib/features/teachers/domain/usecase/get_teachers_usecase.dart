// lib/features/teachers/domain/usecases/get_teachers_usecase.dart



import '../../data/model/teacher_response_model.dart';
import '../repository/teacher_repository.dart';

class GetTeachersUseCase {
  final TeacherRepository repository;

  GetTeachersUseCase({required this.repository});

  Future<TeacherResponseModel> execute() async {
    return await repository.getTeachers();
  }
}
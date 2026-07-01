import '../../data/model/logout_response_model.dart';
import '../repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<LogoutResponseModel> call() {
  return repository.logout();
}
}

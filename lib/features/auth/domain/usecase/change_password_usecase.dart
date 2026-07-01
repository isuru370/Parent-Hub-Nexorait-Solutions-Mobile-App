import '../../data/model/change_password_request.dart';
import '../../data/model/change_password_response.dart';
import '../repository/auth_repository.dart';

class ChangePasswordUseCase {

  final AuthRepository repository;

  ChangePasswordUseCase({
    required this.repository,
  });

  Future<ChangePasswordResponse> call(
    ChangePasswordRequest request,
  ) {
    return repository.changePassword(request);
  }
}
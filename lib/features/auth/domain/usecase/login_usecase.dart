import '../../data/model/login_request.dart';
import '../../data/model/login_response.dart';
import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({
    required this.repository,
  });

  Future<LoginResponseModel> call(
    LoginRequestModel request,
  ) {
    return repository.login(request);
  }
}
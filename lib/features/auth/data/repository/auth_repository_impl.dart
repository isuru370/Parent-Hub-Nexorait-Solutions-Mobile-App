import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../model/change_password_request.dart';
import '../model/change_password_response.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../model/logout_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) {
    return remoteDataSource.login(request);
  }

@override
Future<ChangePasswordResponse> changePassword(
  ChangePasswordRequest request,
) {
  return remoteDataSource.changePassword(request);
}

  @override
Future<LogoutResponseModel> logout() {
  return remoteDataSource.logout();
}
}

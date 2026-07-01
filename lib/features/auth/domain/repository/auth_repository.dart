import '../../data/model/change_password_request.dart';
import '../../data/model/change_password_response.dart';
import '../../data/model/login_request.dart';
import '../../data/model/login_response.dart';
import '../../data/model/logout_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);

  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);

  Future<LogoutResponseModel> logout();
}

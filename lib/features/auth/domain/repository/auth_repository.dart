

import '../../data/model/login_request.dart';
import '../../data/model/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(
    LoginRequestModel request,
  );
}
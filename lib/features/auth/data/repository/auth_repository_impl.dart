import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<LoginResponseModel> login(
    LoginRequestModel request,
  ) {
    return remoteDataSource.login(request);
  }
}
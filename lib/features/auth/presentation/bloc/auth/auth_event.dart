part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final LoginRequestModel loginRequestModel;

  const LoginRequested({
    required this.loginRequestModel,
  });

  @override
  List<Object?> get props => [loginRequestModel];
}

class SaveFcmTokenRequested extends AuthEvent {
  const SaveFcmTokenRequested();
}

class ChangePasswordRequested extends AuthEvent {

  final ChangePasswordRequest request;

  const ChangePasswordRequested({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
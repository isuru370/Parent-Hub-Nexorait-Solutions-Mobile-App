import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/device_info_service.dart';
import '../../../../../core/services/fcm_service.dart';
import '../../../../../core/storage/storage_keys.dart';
import '../../../../../core/storage/storage_service.dart';
import '../../../../notification/data/model/fcm/save_fcm_token_request.dart';
import '../../../../notification/domain/usecase/save_fcm_token_usecase.dart';
import '../../../data/model/change_password_request.dart';
import '../../../data/model/login_request.dart';
import '../../../data/model/login_response.dart';
import '../../../domain/usecase/change_password_usecase.dart';
import '../../../domain/usecase/login_usecase.dart';
import '../../../domain/usecase/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SaveFcmTokenUseCase saveFcmTokenUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.saveFcmTokenUseCase,
    required this.changePasswordUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SaveFcmTokenRequested>(_onSaveFcmTokenRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await loginUseCase(event.loginRequestModel);

      if (response.status) {
        emit(AuthSuccess(loginResponse: response));

        add(const SaveFcmTokenRequested());
      } else {
        emit(AuthFailure(message: response.message));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onSaveFcmTokenRequested(
    SaveFcmTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await FCMService.instance.getToken();

      if (token == null || token.trim().isEmpty) {
        debugPrint('FCM Token not available');
        return;
      }

      final deviceId = await DeviceInfoService.getDeviceId();
      final deviceName = await DeviceInfoService.getDeviceName();
      final deviceType = DeviceInfoService.getDeviceType();
      final appVersion = await DeviceInfoService.getAppVersion();

      final student = StorageService.getJson(StorageKeys.student);

      if (student == null) {
        return;
      }

      final response = await saveFcmTokenUseCase(
        SaveFcmTokenRequest(
          studentId: student['student_id'],
          token: token,
          deviceId: deviceId,
          deviceName: deviceName,
          deviceType: deviceType,
          appVersion: appVersion,
        ),
      );

      if (response.status) {
        debugPrint('FCM Token saved successfully');
      } else {
        debugPrint('FCM Token save failed : ${response.message}');
      }
    } catch (e) {
      debugPrint('Save FCM Token Error : $e');
    }
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await changePasswordUseCase(event.request);

      if (response.status) {
        emit(ChangePasswordSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await logoutUseCase();

      if (response.status) {
        emit(LogoutSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}

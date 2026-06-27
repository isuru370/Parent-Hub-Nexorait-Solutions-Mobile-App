import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/device_info_service.dart';
import '../../../../../core/services/fcm_service.dart';
import '../../../../../core/storage/storage_keys.dart';
import '../../../../../core/storage/storage_service.dart';
import '../../../../notification/data/model/save_fcm_token_request.dart';
import '../../../../notification/domain/usecase/save_fcm_token_usecase.dart';
import '../../../data/model/login_request.dart';
import '../../../data/model/login_response.dart';
import '../../../domain/usecase/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SaveFcmTokenUseCase saveFcmTokenUseCase;

  AuthBloc({required this.loginUseCase, required this.saveFcmTokenUseCase})
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SaveFcmTokenRequested>(_onSaveFcmTokenRequested);
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

      final deviceName = await DeviceInfoService.getDeviceName();
      final deviceType = DeviceInfoService.getDeviceType();
      final appVersion = await DeviceInfoService.getAppVersion();
      final student = StorageService.getJson(StorageKeys.student);

      if (student == null) {
        return;
      }

      final studentId = student['student_id'];

      final response = await saveFcmTokenUseCase(
        SaveFcmTokenRequest(
          studentId: studentId,
          token: token,
          deviceName: deviceName,
          deviceType: deviceType,
          appVersion: appVersion,
        ),
      );

      if (response.status) {
        debugPrint('FCM Token saved successfully');
      } else {
        debugPrint('FCM Token save failed: ${response.message}');
      }
    } catch (e) {
      debugPrint('Save FCM Token Error: $e');
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/save_fcm_token_request.dart';
import '../../../domain/usecase/save_fcm_token_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SaveFcmTokenUseCase saveFcmTokenUseCase;

  NotificationBloc({required this.saveFcmTokenUseCase})
    : super(NotificationInitial()) {
    on<SaveFcmTokenRequested>(_saveToken);
  }

  Future<void> _saveToken(
    SaveFcmTokenRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final response = await saveFcmTokenUseCase(event.request);

      if (response.status) {
        emit(NotificationSuccess());
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }
}

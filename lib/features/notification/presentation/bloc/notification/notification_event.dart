part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class SaveFcmTokenRequested extends NotificationEvent {
  final SaveFcmTokenRequest request;

  const SaveFcmTokenRequested({required this.request});

  @override
  List<Object> get props => [request];
}

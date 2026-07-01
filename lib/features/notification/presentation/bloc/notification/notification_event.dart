part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

// FCM
class SaveFcmTokenRequested extends NotificationEvent {
  final SaveFcmTokenRequest request;

  const SaveFcmTokenRequested({required this.request});

  @override
  List<Object> get props => [request];
}

// Notifications
class LoadNotificationsEvent extends NotificationEvent {
  final String? status;
  final String? type;
  final String? dateFrom;
  final String? dateTo;
  final String? search;
  final int page;
  final int perPage;

  const LoadNotificationsEvent({
    this.status,
    this.type,
    this.dateFrom,
    this.dateTo,
    this.search,
    this.page = 1,
    this.perPage = 20,
  });

  @override
  List<Object> get props => [
    status ?? '',
    type ?? '',
    dateFrom ?? '',
    dateTo ?? '',
    search ?? '',
    page,
    perPage,
  ];
}

class LoadNotificationDetailsEvent extends NotificationEvent {
  final int notificationId;

  const LoadNotificationDetailsEvent({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class LoadUnreadNotificationsEvent extends NotificationEvent {
  final int? limit;

  const LoadUnreadNotificationsEvent({this.limit = 20});

  @override
  List<Object> get props => [limit ?? 20];
}

class LoadUnreadCountEvent extends NotificationEvent {}

class MarkAsReadEvent extends NotificationEvent {
  final int notificationId;

  const MarkAsReadEvent({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class MarkAllAsReadEvent extends NotificationEvent {}

class DeleteNotificationEvent extends NotificationEvent {
  final int notificationId;

  const DeleteNotificationEvent({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class DeleteReadNotificationsEvent extends NotificationEvent {}

class RefreshNotificationsEvent extends NotificationEvent {}

class LoadStatsEvent extends NotificationEvent {}

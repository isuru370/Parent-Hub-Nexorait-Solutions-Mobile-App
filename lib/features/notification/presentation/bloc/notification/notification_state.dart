part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

// ============================================
// INITIAL
// ============================================
final class NotificationInitial extends NotificationState {}

// ============================================
// FCM STATES
// ============================================
final class NotificationLoading extends NotificationState {}

final class NotificationSuccess extends NotificationState {}

final class NotificationFailure extends NotificationState {
  final String message;

  const NotificationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// ============================================
// NOTIFICATION LIST STATES
// ============================================
final class NotificationListLoaded extends NotificationState {
  final List<NotificationModel> items;
  final int total;
  final int currentPage;
  final int lastPage;
  final Map<String, dynamic> stats;

  const NotificationListLoaded({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.stats,
  });

  @override
  List<Object> get props => [
        items,
        total,
        currentPage,
        lastPage,
        stats,
      ];
}

// ============================================
// UNREAD NOTIFICATIONS STATE
// ============================================
final class UnreadNotificationsLoaded extends NotificationState {
  final List<NotificationModel> items;
  final int totalUnread;

  const UnreadNotificationsLoaded({
    required this.items,
    required this.totalUnread,
  });

  @override
  List<Object> get props => [
        items,
        totalUnread,
      ];
}

// ============================================
// NOTIFICATION DETAILS STATE
// ============================================
final class NotificationDetailsLoaded extends NotificationState {
  final NotificationModel notification;

  const NotificationDetailsLoaded({required this.notification});

  @override
  List<Object> get props => [notification];
}

// ============================================
// UNREAD COUNT STATE
// ============================================
final class UnreadCountLoaded extends NotificationState {
  final int count;

  const UnreadCountLoaded({required this.count});

  @override
  List<Object> get props => [count];
}

// ============================================
// STATS STATE
// ============================================
final class StatsLoaded extends NotificationState {
  final Map<String, dynamic> stats;

  const StatsLoaded({required this.stats});

  @override
  List<Object> get props => [stats];
}

// ============================================
// OPERATION SUCCESS STATE
// ============================================
final class NotificationOperationSuccess extends NotificationState {
  final String message;
  final int? count;

  const NotificationOperationSuccess({
    required this.message,
    this.count,
  });

  @override
  List<Object> get props => [
        message,
        count ?? 0, // Nullable value handle කරන්න
      ];
}
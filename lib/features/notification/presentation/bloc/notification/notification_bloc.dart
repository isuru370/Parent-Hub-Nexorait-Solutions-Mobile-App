import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/fcm/save_fcm_token_request.dart';
import '../../../data/model/fcm/save_fcm_token_response.dart';
import '../../../data/model/notification/notification_model.dart';
import '../../../data/model/notification/notification_list_response.dart';
import '../../../data/model/notification/notification_detail_response.dart';
import '../../../data/model/notification/unread_count_response.dart';
import '../../../data/model/notification/operation_response.dart';
import '../../../data/model/notification/stats_response.dart';
import '../../../domain/usecase/save_fcm_token_usecase.dart';
import '../../../domain/usecase/get_notifications_usecase.dart';
import '../../../domain/usecase/get_notification_details_usecase.dart';
import '../../../domain/usecase/get_unread_notifications_usecase.dart';
import '../../../domain/usecase/get_unread_count_usecase.dart';
import '../../../domain/usecase/mark_as_read_usecase.dart';
import '../../../domain/usecase/mark_all_as_read_usecase.dart';
import '../../../domain/usecase/delete_notification_usecase.dart';
import '../../../domain/usecase/delete_read_notifications_usecase.dart';
import '../../../domain/usecase/get_stats_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  // FCM
  final SaveFcmTokenUseCase saveFcmTokenUseCase;

  // Notifications
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetNotificationDetailsUseCase getNotificationDetailsUseCase;
  final GetUnreadNotificationsUseCase getUnreadNotificationsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final DeleteReadNotificationsUseCase deleteReadNotificationsUseCase;
  final GetStatsUseCase getStatsUseCase;

  NotificationBloc({
    required this.saveFcmTokenUseCase,
    required this.getNotificationsUseCase,
    required this.getNotificationDetailsUseCase,
    required this.getUnreadNotificationsUseCase,
    required this.getUnreadCountUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
    required this.deleteNotificationUseCase,
    required this.deleteReadNotificationsUseCase,
    required this.getStatsUseCase,
  }) : super(NotificationInitial()) {
    // FCM
    on<SaveFcmTokenRequested>(_onSaveFcmToken);

    // Notifications
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<LoadNotificationDetailsEvent>(_onLoadNotificationDetails);
    on<LoadUnreadNotificationsEvent>(_onLoadUnreadNotifications);
    on<LoadUnreadCountEvent>(_onLoadUnreadCount);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<DeleteReadNotificationsEvent>(_onDeleteReadNotifications);
    on<RefreshNotificationsEvent>(_onRefreshNotifications);
    on<LoadStatsEvent>(_onLoadStats);
  }

  // ============================================
  // FCM TOKEN
  // ============================================
  Future<void> _onSaveFcmToken(
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

  // ============================================
  // LOAD NOTIFICATIONS
  // ============================================
  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final response = await getNotificationsUseCase(
        status: event.status,
        type: event.type,
        dateFrom: event.dateFrom,
        dateTo: event.dateTo,
        search: event.search,
        page: event.page,
        perPage: event.perPage,
      );

      if (response.success && response.data != null) {
        emit(NotificationListLoaded(
          items: response.data!.items,
          total: response.data!.pagination.total,
          currentPage: response.data!.pagination.currentPage,
          lastPage: response.data!.pagination.lastPage,
          stats: {
            'total': response.data!.stats.total,
            'unread': response.data!.stats.unread,
            'read': response.data!.stats.read,
            'by_type': response.data!.stats.byType,
          },
        ));
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  // ============================================
  // LOAD NOTIFICATION DETAILS
  // ============================================
  Future<void> _onLoadNotificationDetails(
    LoadNotificationDetailsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final response = await getNotificationDetailsUseCase(
        event.notificationId,
      );

      if (response.success && response.data != null) {
        emit(NotificationDetailsLoaded(notification: response.data!));
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  // ============================================
  // LOAD UNREAD NOTIFICATIONS
  // ============================================
  Future<void> _onLoadUnreadNotifications(
    LoadUnreadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final items = await getUnreadNotificationsUseCase(limit: event.limit);

      // Get unread count separately
      final countResponse = await getUnreadCountUseCase();

      emit(UnreadNotificationsLoaded(
        items: items,
        totalUnread: countResponse.data?.unreadCount ?? 0,
      ));
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  // ============================================
  // LOAD UNREAD COUNT
  // ============================================
  Future<void> _onLoadUnreadCount(
    LoadUnreadCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final response = await getUnreadCountUseCase();

      if (response.success && response.data != null) {
        emit(UnreadCountLoaded(count: response.data!.unreadCount));
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  // ============================================
  // MARK AS READ
  // ============================================
  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final response = await markAsReadUseCase(event.notificationId);

      if (response.success) {
        emit(NotificationOperationSuccess(
          message: response.message,
          count: response.data?['marked_count'],
        ));
        add(RefreshNotificationsEvent());
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  // ============================================
  // MARK ALL AS READ
  // ============================================
  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final response = await markAllAsReadUseCase();

      if (response.success) {
        emit(NotificationOperationSuccess(
          message: response.message,
          count: response.data?['marked_count'],
        ));
        add(RefreshNotificationsEvent());
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  // ============================================
  // DELETE NOTIFICATION
  // ============================================
  Future<void> _onDeleteNotification(
    DeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final response = await deleteNotificationUseCase(event.notificationId);

      if (response.success) {
        emit(NotificationOperationSuccess(
          message: response.message,
        ));
        add(RefreshNotificationsEvent());
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  // ============================================
  // DELETE READ NOTIFICATIONS
  // ============================================
  Future<void> _onDeleteReadNotifications(
    DeleteReadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final response = await deleteReadNotificationsUseCase();

      if (response.success) {
        emit(NotificationOperationSuccess(
          message: response.message,
          count: response.data?['deleted_count'],
        ));
        add(RefreshNotificationsEvent());
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  // ============================================
  // REFRESH
  // ============================================
  Future<void> _onRefreshNotifications(
    RefreshNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    add(const LoadNotificationsEvent());
  }

  // ============================================
  // LOAD STATS
  // ============================================
  Future<void> _onLoadStats(
    LoadStatsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final response = await getStatsUseCase();

      if (response.success && response.data != null) {
        emit(StatsLoaded(
          stats: {
            'total': response.data!.total,
            'unread': response.data!.unread,
            'read': response.data!.read,
            'by_type': response.data!.byType,
          },
        ));
      } else {
        emit(NotificationFailure(message: response.message));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }
}
import 'notification_model.dart';

class NotificationListResponse {
  final bool success;
  final String message;
  final NotificationListData? data;

  NotificationListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationListResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? NotificationListData.fromJson(json["data"])
          : null,
    );
  }
}

class NotificationListData {
  final List<NotificationModel> items;
  final PaginationData pagination;
  final NotificationStats stats;

  NotificationListData({
    required this.items,
    required this.pagination,
    required this.stats,
  });

  factory NotificationListData.fromJson(Map<String, dynamic> json) {
    return NotificationListData(
      items: json["items"] != null
          ? (json["items"] as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList()
          : [],
      pagination: json["pagination"] != null
          ? PaginationData.fromJson(json["pagination"])
          : PaginationData(total: 0, perPage: 20, currentPage: 1, lastPage: 1),
      stats: json["stats"] != null
          ? NotificationStats.fromJson(json["stats"])
          : NotificationStats(total: 0, unread: 0, read: 0, byType: {}),
    );
  }
}

class PaginationData {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  PaginationData({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      total: json["total"] ?? 0,
      perPage: json["per_page"] ?? 20,
      currentPage: json["current_page"] ?? 1,
      lastPage: json["last_page"] ?? 1,
    );
  }
}

class NotificationStats {
  final int total;
  final int unread;
  final int read;
  final Map<String, int> byType;

  NotificationStats({
    required this.total,
    required this.unread,
    required this.read,
    required this.byType,
  });

  factory NotificationStats.fromJson(Map<String, dynamic> json) {
    return NotificationStats(
      total: json["total"] ?? 0,
      unread: json["unread"] ?? 0,
      read: json["read"] ?? 0,
      byType: json["by_type"] != null
          ? Map<String, int>.from(json["by_type"])
          : {},
    );
  }
}
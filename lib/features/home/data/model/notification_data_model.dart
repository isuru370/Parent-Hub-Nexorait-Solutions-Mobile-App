class NotificationDataModel {
  final int unreadCount;
  final List<UnreadNotificationModel> latestUnread;

  NotificationDataModel({
    required this.unreadCount,
    required this.latestUnread,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      unreadCount: json["unread_count"] ?? 0,
      latestUnread: (json["latest_unread"] as List? ?? [])
          .map((e) => UnreadNotificationModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "unread_count": unreadCount,
      "latest_unread": latestUnread.map((e) => e.toJson()).toList(),
    };
  }
}

class UnreadNotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final String createdAt;

  UnreadNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
  });

  factory UnreadNotificationModel.fromJson(Map<String, dynamic> json) {
    return UnreadNotificationModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      type: json["type"] ?? "general",
      createdAt: json["created_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "type": type,
      "created_at": createdAt,
    };
  }
}
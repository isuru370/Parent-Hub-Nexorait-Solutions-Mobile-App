class UnreadCountResponse {
  final bool success;
  final String message;
  final UnreadCountData? data;

  UnreadCountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? UnreadCountData.fromJson(json["data"])
          : null,
    );
  }
}

class UnreadCountData {
  final int unreadCount;

  UnreadCountData({
    required this.unreadCount,
  });

  factory UnreadCountData.fromJson(Map<String, dynamic> json) {
    return UnreadCountData(
      unreadCount: json["unread_count"] ?? 0,
    );
  }
}
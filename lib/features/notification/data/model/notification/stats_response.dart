import 'notification_list_response.dart';

class StatsResponse {
  final bool success;
  final String message;
  final NotificationStats? data;

  StatsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? NotificationStats.fromJson(json["data"])
          : null,
    );
  }
}
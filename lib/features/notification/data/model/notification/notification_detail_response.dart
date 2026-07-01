import 'notification_model.dart';

class NotificationDetailResponse {
  final bool success;
  final String message;
  final NotificationModel? data;

  NotificationDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory NotificationDetailResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDetailResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? NotificationModel.fromJson(json["data"])
          : null,
    );
  }
}
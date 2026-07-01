
class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final String typeLabel;
  final String typeIcon;
  final String status;
  final String statusLabel;
  final bool isRead;
  final String? readAt;
  final String? sentAt;
  final String? scheduledAt;
  final String createdAt;
  final StudentInfo? student;
  final CreatedByInfo? createdBy;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.typeLabel,
    required this.typeIcon,
    required this.status,
    required this.statusLabel,
    required this.isRead,
    required this.readAt,
    required this.sentAt,
    this.scheduledAt,
    required this.createdAt,
    this.student,
    this.createdBy,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      type: json["type"] ?? "general",
      typeLabel: json["type_label"] ?? "General",
      typeIcon: json["type_icon"] ?? "fa-bell",
      status: json["status"] ?? "pending",
      statusLabel: json["status_label"] ?? "Pending",
      isRead: json["is_read"] ?? false,
      readAt: json["read_at"],
      sentAt: json["sent_at"],
      scheduledAt: json["scheduled_at"],
      createdAt: json["created_at"] ?? "",
      student: json["student"] != null
          ? StudentInfo.fromJson(json["student"])
          : null,
      createdBy: json["created_by"] != null
          ? CreatedByInfo.fromJson(json["created_by"])
          : null,
      data: json["data"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "type": type,
      "type_label": typeLabel,
      "type_icon": typeIcon,
      "status": status,
      "status_label": statusLabel,
      "is_read": isRead,
      "read_at": readAt,
      "sent_at": sentAt,
      "scheduled_at": scheduledAt,
      "created_at": createdAt,
      "student": student?.toJson(),
      "created_by": createdBy?.toJson(),
      "data": data,
    };
  }
}

class StudentInfo {
  final int id;
  final String name;
  final String? customId;

  StudentInfo({
    required this.id,
    required this.name,
    this.customId,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Student",
      customId: json["custom_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "custom_id": customId,
    };
  }
}

class CreatedByInfo {
  final int id;
  final String name;

  CreatedByInfo({
    required this.id,
    required this.name,
  });

  factory CreatedByInfo.fromJson(Map<String, dynamic> json) {
    return CreatedByInfo(
      id: json["id"] ?? 0,
      name: json["name"] ?? "System",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
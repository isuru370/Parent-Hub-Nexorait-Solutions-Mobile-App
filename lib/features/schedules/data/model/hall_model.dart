// lib/features/schedules/data/models/hall_model.dart

class HallModel {
  final int id;
  final String hallName;

  HallModel({
    required this.id,
    required this.hallName,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      id: json['id'] ?? 0,
      hallName: json['hall_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hall_name': hallName,
    };
  }
}
// lib/features/exams/data/models/exam_hall_model.dart

class ExamHallModel {
  final int id;
  final String name;

  ExamHallModel({
    required this.id,
    required this.name,
  });

  factory ExamHallModel.fromJson(Map<String, dynamic> json) {
    return ExamHallModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
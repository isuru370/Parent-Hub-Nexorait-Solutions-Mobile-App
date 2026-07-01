// lib/features/exams/data/models/exam_category_model.dart

class ExamCategoryModel {
  final int id;
  final String name;

  ExamCategoryModel({
    required this.id,
    required this.name,
  });

  factory ExamCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExamCategoryModel(
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
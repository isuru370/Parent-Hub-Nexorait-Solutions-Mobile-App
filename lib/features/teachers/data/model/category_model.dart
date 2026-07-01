// lib/features/teachers/data/models/category_model.dart

class CategoryModel {
  final int id;
  final String categoryName;
  final PivotModel? pivot;

  CategoryModel({
    required this.id,
    required this.categoryName,
    this.pivot,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      pivot: json['pivot'] != null
          ? PivotModel.fromJson(json['pivot'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'pivot': pivot?.toJson(),
    };
  }
}

class PivotModel {
  final int studentClassId;
  final int classCategoryId;
  final int id;
  final String fee;
  final int isActive;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  PivotModel({
    required this.studentClassId,
    required this.classCategoryId,
    required this.id,
    required this.fee,
    required this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PivotModel.fromJson(Map<String, dynamic> json) {
    return PivotModel(
      studentClassId: json['student_class_id'] ?? 0,
      classCategoryId: json['class_category_id'] ?? 0,
      id: json['id'] ?? 0,
      fee: json['fee']?.toString() ?? '0.00',
      isActive: json['is_active'] ?? 0,
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_class_id': studentClassId,
      'class_category_id': classCategoryId,
      'id': id,
      'fee': fee,
      'is_active': isActive,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
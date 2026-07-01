// lib/features/schedules/data/models/class_category_fee_model.dart

import 'category_model.dart';

class ClassCategoryFeeModel {
  final int id;
  final int classCategoryId;
  final CategoryModel? category;

  ClassCategoryFeeModel({
    required this.id,
    required this.classCategoryId,
    this.category,
  });

  factory ClassCategoryFeeModel.fromJson(Map<String, dynamic> json) {
    return ClassCategoryFeeModel(
      id: json['id'] ?? 0,
      classCategoryId: json['class_category_id'] ?? 0,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_category_id': classCategoryId,
      'category': category?.toJson(),
    };
  }
}
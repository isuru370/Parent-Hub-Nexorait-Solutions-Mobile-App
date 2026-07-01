// lib/features/teachers/data/models/class_model.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'category_model.dart';
import 'grade_model.dart';

class ClassModel {
  final int id;
  final int teacherId;
  final String className;
  final String medium;
  final String classType;
  final int gradeId;
  final bool isActive;
  final bool isOngoing;
  final bool isMyClass;
  final GradeModel grade;
  final List<CategoryModel> categories;

  ClassModel({
    required this.id,
    required this.teacherId,
    required this.className,
    required this.medium,
    required this.classType,
    required this.gradeId,
    required this.isActive,
    required this.isOngoing,
    required this.isMyClass,
    required this.grade,
    required this.categories,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    // ✅ Debug: Print raw value from JSON
    print('🔍 Class: ${json['class_name']}');
    print('🔍 is_my_class raw value: ${json['is_my_class']}');
    print('🔍 is_my_class type: ${json['is_my_class'].runtimeType}');

    // ✅ Fix: Convert properly
    final bool isMyClassValue = _parseBool(json['is_my_class']);
    print('🔍 is_my_class parsed: $isMyClassValue');

    return ClassModel(
      id: json['id'] ?? 0,
      teacherId: json['teacher_id'] ?? 0,
      className: json['class_name'] ?? '',
      medium: json['medium'] ?? '',
      classType: json['class_type'] ?? '',
      gradeId: json['grade_id'] ?? 0,
      isActive: _parseBool(json['is_active']),
      isOngoing: _parseBool(json['is_ongoing']),
      isMyClass: isMyClassValue, // ✅ Use parsed value
      grade: GradeModel.fromJson(json['grade'] ?? {}),
      categories: (json['categories'] as List? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
    );
  }

  // ✅ Robust boolean parser
  static bool _parseBool(dynamic value) {
    if (value == null) return false;

    // If it's already a bool
    if (value is bool) return value;

    // If it's an int (0 or 1)
    if (value is int) return value == 1;

    // If it's a String
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }

    // If it's a double
    if (value is double) return value == 1.0;

    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'class_name': className,
      'medium': medium,
      'class_type': classType,
      'grade_id': gradeId,
      'is_active': isActive,
      'is_ongoing': isOngoing,
      'is_my_class': isMyClass,
      'grade': grade.toJson(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }

  // =========================================================
  // HELPER GETTERS
  // =========================================================

  String get displayName => className;
  String get mediumDisplay => medium.isNotEmpty ? medium : 'N/A';
  String get typeDisplay => classType.isNotEmpty ? classType : 'N/A';
  String get gradeName => grade.gradeName;
  String get categoryNames => categories.map((c) => c.categoryName).join(', ');
  bool get hasCategories => categories.isNotEmpty;

  String get statusDisplay {
    if (!isActive) return 'Inactive';
    if (isOngoing) return 'Ongoing';
    return 'Active';
  }

  Color get statusColor {
    if (!isActive) return Colors.grey;
    if (isOngoing) return Colors.green;
    return AppColors.primaryBlue;
  }

  IconData get statusIcon {
    if (!isActive) return Icons.cancel;
    if (isOngoing) return Icons.play_circle;
    return Icons.check_circle;
  }

  Color get enrollmentColor =>
      isMyClass ? Colors.green : AppColors.textSecondary;
  String get enrollmentLabel => isMyClass ? 'Enrolled' : 'Not Enrolled';
  IconData get enrollmentIcon =>
      isMyClass ? Icons.check_circle : Icons.circle_outlined;
}

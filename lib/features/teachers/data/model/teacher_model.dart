// lib/features/teachers/data/models/teacher_model.dart

import 'package:flutter/material.dart';

import 'class_model.dart';

class TeacherModel {
  final int id;
  final String customId;
  final String fullName;
  final String initials;
  final String mobile;
  final String email;
  final bool isActive;
  final bool isMyTeacher;
  final List<ClassModel> classes;

  TeacherModel({
    required this.id,
    required this.customId,
    required this.fullName,
    required this.initials,
    required this.mobile,
    required this.email,
    required this.isActive,
    required this.isMyTeacher,
    required this.classes,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    print('👨‍🏫 Teacher: ${json['full_name']}');

    final isMyTeacher = json['is_my_teacher'] ?? false;
    print('📌 is_my_teacher from API: $isMyTeacher');

    final classesList = (json['classes'] as List? ?? []).map((e) {
      // ✅ ClassModel.fromJson already parses is_my_class correctly
      final classData = ClassModel.fromJson(e);

      print(
        '   📚 ${classData.className} (Gr.${classData.gradeName}) - isMyClass: ${classData.isMyClass}',
      );

      // ✅ Return classData WITHOUT overriding isMyClass
      return classData;
    }).toList();

    print('📚 Total Classes: ${classesList.length}');
    for (var classItem in classesList) {
      print(
        '   📚 ${classItem.className} (Gr.${classItem.gradeName}) - isMyClass: ${classItem.isMyClass}',
      );
    }

    return TeacherModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'] ?? '',
      fullName: json['full_name'] ?? '',
      initials: json['initials'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? false,
      isMyTeacher: isMyTeacher,
      classes: classesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'custom_id': customId,
      'full_name': fullName,
      'initials': initials,
      'mobile': mobile,
      'email': email,
      'is_active': isActive,
      'is_my_teacher': isMyTeacher,
      'classes': classes.map((e) => e.toJson()).toList(),
    };
  }

  // =========================================================
  // HELPER GETTERS
  // =========================================================

  String get displayName => fullName;
  String get shortName => initials;
  String get statusDisplay => isActive ? 'Active' : 'Inactive';
  Color get statusColor => isActive ? Colors.green : Colors.grey;
  int get totalClasses => classes.length;

  // ✅ Check if teacher has any enrolled class
  bool get hasMyClasses => classes.any((c) => c.isMyClass);

  // ✅ Get enrolled classes
  List<ClassModel> get myClasses => classes.where((c) => c.isMyClass).toList();

  // ✅ Get other classes
  List<ClassModel> get otherClasses =>
      classes.where((c) => !c.isMyClass).toList();
}

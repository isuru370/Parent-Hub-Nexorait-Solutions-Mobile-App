// lib/features/schedules/data/models/teacher_model.dart

class TeacherModel {
  final int id;
  final String fullName;
  final String mobile;

  TeacherModel({
    required this.id,
    required this.fullName,
    required this.mobile,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'mobile': mobile,
    };
  }
}
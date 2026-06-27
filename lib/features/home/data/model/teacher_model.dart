class TeacherModel {
  final int id;
  final String fullName;

  TeacherModel({
    required this.id,
    required this.fullName,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json["id"],
      fullName: json["full_name"],
    );
  }
}
// lib/features/results/data/models/exam_detail_model.dart

class ExamDetailModel {
  final int id;
  final String title;
  final String examDate;
  final String startTime;
  final String endTime;
  final String status;
  final StudentClassModel studentClass;
  final SubjectModel subject;
  final TeacherModel teacher;
  final CategoryModel category;
  final HallModel hall;

  ExamDetailModel({
    required this.id,
    required this.title,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.studentClass,
    required this.subject,
    required this.teacher,
    required this.category,
    required this.hall,
  });

  factory ExamDetailModel.fromJson(Map<String, dynamic> json) {
    return ExamDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      examDate: json['exam_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      status: json['status'] ?? '',
      studentClass: StudentClassModel.fromJson(json['student_class'] ?? {}),
      subject: SubjectModel.fromJson(json['subject'] ?? {}),
      teacher: TeacherModel.fromJson(json['teacher'] ?? {}),
      category: CategoryModel.fromJson(json['category'] ?? {}),
      hall: HallModel.fromJson(json['hall'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'exam_date': examDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'student_class': studentClass.toJson(),
      'subject': subject.toJson(),
      'teacher': teacher.toJson(),
      'category': category.toJson(),
      'hall': hall.toJson(),
    };
  }
}

class StudentClassModel {
  final int id;
  final String className;

  StudentClassModel({
    required this.id,
    required this.className,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: json['id'] ?? 0,
      className: json['class_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
    };
  }
}

class SubjectModel {
  final int id;
  final String subjectName;

  SubjectModel({
    required this.id,
    required this.subjectName,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? 0,
      subjectName: json['subject_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_name': subjectName,
    };
  }
}

class TeacherModel {
  final int id;
  final String fullName;

  TeacherModel({
    required this.id,
    required this.fullName,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
    };
  }
}

class CategoryModel {
  final int id;
  final String categoryName;

  CategoryModel({
    required this.id,
    required this.categoryName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
    };
  }
}

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
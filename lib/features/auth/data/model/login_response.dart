import 'student_model.dart';

class LoginResponseModel {
  final bool status;
  final String message;
  final String apiUrl;
  final StudentModel? student;

  const LoginResponseModel({
    required this.status,
    required this.message,
    required this.apiUrl,
    this.student,
  });

  factory LoginResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      apiUrl: json['api_url'] ?? '',
      student: json['data'] != null
          ? StudentModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'api_url': apiUrl,
      'data': student?.toJson(),
    };
  }
}
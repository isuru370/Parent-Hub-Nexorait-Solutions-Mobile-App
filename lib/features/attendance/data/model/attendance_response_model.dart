import 'attendance_data_model.dart';

class AttendanceResponseModel {
  final bool status;
  final String message;
  final AttendanceDataModel data;

  AttendanceResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: AttendanceDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

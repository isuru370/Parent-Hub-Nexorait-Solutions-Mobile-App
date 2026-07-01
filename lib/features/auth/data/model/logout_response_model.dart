class LogoutResponseModel {
  final bool status;
  final String message;

  const LogoutResponseModel({
    required this.status,
    required this.message,
  });

  factory LogoutResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LogoutResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
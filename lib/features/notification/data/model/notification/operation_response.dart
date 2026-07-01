class OperationResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  OperationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OperationResponse.fromJson(Map<String, dynamic> json) {
    return OperationResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"],
    );
  }
}
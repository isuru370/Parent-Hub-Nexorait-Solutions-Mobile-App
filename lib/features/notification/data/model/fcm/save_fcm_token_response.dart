class SaveFcmTokenResponse {
  final bool status;
  final String message;

  const SaveFcmTokenResponse({required this.status, required this.message});

  factory SaveFcmTokenResponse.fromJson(Map<String, dynamic> json) {
    return SaveFcmTokenResponse(
      status: json["status"],
      message: json["message"],
    );
  }
}

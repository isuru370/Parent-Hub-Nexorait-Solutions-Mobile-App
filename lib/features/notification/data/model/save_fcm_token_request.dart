class SaveFcmTokenRequest {
  final int studentId;
  final String token;
  final String deviceName;
  final String deviceType;
  final String appVersion;

  const SaveFcmTokenRequest({
    required this.studentId,
    required this.token,
    required this.deviceName,
    required this.deviceType,
    required this.appVersion,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'token': token,
      'device_name': deviceName,
      'device_type': deviceType,
      'app_version': appVersion,
    };
  }
}
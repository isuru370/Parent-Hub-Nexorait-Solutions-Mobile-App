class ChangePasswordRequest {
  final int studentId;
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const ChangePasswordRequest({
    required this.studentId,
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      "student_id": studentId,
      "current_password": currentPassword,
      "new_password": newPassword,
      "new_password_confirmation": newPasswordConfirmation,
    };
  }
}
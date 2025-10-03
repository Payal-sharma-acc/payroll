class ResetPasswordModel {
  final String resetToken;
  final String newPassword;

  ResetPasswordModel({
    required this.resetToken,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'resetToken': resetToken,
      'newPassword': newPassword,
    };
  }
}

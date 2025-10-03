class ForgotOtpModel {
  final String message;
  final String resetToken;
  final bool success;

  ForgotOtpModel({
    required this.message,
    required this.resetToken,
    required this.success,
  });

  factory ForgotOtpModel.fromJson(Map<String, dynamic> json) {
    return ForgotOtpModel(
      message: json['message'] ?? '',
      resetToken: json['resetToken'] ?? '',
      success: json.containsKey('success')
          ? json['success']
          : json['resetToken'] != null && json['resetToken'].toString().isNotEmpty,
    );
  }
}

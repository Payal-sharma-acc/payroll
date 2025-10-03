class ForgotPasswordModel {
  final String emailOrPhone;

  ForgotPasswordModel({required this.emailOrPhone});

  Map<String, dynamic> toJson() {
    return {
      "emailOrPhone": emailOrPhone,
    };
  }
}

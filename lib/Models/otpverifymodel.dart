class Otpverifymodel {
  final String emailOrPhone;
  final String otp;

  Otpverifymodel({required this.emailOrPhone, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone':emailOrPhone,
      'otp': otp,
    };
  }
}

class Loginnumberotpmodel {
  final String emailOrPhone;
  final String otp;

  Loginnumberotpmodel({required this.emailOrPhone, required this.otp});

  Map<String, dynamic> toJson() => {
        "emailOrPhone": emailOrPhone, 
        "otp": otp,
      };
}

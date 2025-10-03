class Loginwithotpmodel {
  final String emailOrPhone;

  Loginwithotpmodel({required this.emailOrPhone});

  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone': emailOrPhone,
    };
  }

  factory Loginwithotpmodel.fromJson(Map<String, dynamic> json) {
    return Loginwithotpmodel(
      emailOrPhone: json['emailOrPhone'] ?? '',
    );
  }
}

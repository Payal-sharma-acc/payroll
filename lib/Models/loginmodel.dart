class Loginmodel {
  final String emailOrPhone;
  final String password;


  Loginmodel({
    required this.emailOrPhone,
    required this.password,

  });
  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone': emailOrPhone,
      'password': password,
   
    };
  }
  factory Loginmodel.fromJson(Map<String, dynamic> json) {
    return Loginmodel(
      emailOrPhone: json['emailOrPhone'] ?? '',
      password: json['password'] ?? '',
     
    );
  }
}

class SignupModel {
  final String emailOrPhone;
  final String password;
  final String role;
  final String name;

  SignupModel({
    required this.emailOrPhone,
    required this.password,
    required this.role,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone': emailOrPhone,
      'password': password,
      'role': role,
      'name': name,
    };
  }
}

class Logoutmodel {
  final String refreshToken;

  Logoutmodel({required this.refreshToken});


  Map<String, dynamic> toJson() {
    return {
      "refreshToken": refreshToken,
    };
  }

  
  factory Logoutmodel.fromJson(Map<String, dynamic> json) {
    return Logoutmodel(
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}

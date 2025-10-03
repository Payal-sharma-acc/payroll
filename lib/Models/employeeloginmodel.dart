class EmployeeLoginModel {
  final String? email;
  final String? password;
  final int? employeeId;
  final String? fullName;
  final String? token;
  final int? companyId; 
  final String? message;

  EmployeeLoginModel({
    this.email,
    this.password,
    this.employeeId,
    this.fullName,
    this.token,
    this.companyId,
    this.message,
  });
  Map<String, dynamic> toJsonRequest() {
    return {
      "email": email,
      "password": password,
    };
  }
factory EmployeeLoginModel.fromJson(Map<String, dynamic> json) {
  return EmployeeLoginModel(
    employeeId: json['employeeId'],
    fullName: json['fullName'] ?? json['name'] ?? json['userName'], 
    email: json['email'],
    token: json['token'],
    companyId: json['companyId'], 
    message: json['message'],
  );
}

}

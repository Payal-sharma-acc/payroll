class Employeeprofilemodel {
  final int employeeId;
  final String dateOfBirth;
  final String fatherName;
  final String pan;
  final String differentlyAbledType;
  final String personalEmailAddress;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pinCode;

  Employeeprofilemodel({
    required this.employeeId,
    required this.dateOfBirth,
    required this.fatherName,
    required this.pan,
    required this.differentlyAbledType,
    required this.personalEmailAddress,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pinCode,
  });

  factory Employeeprofilemodel.fromJson(Map<String, dynamic> json) {
    return Employeeprofilemodel(
      employeeId: json['employeeId'] ?? 0,
      dateOfBirth: json['dateOfBirth'] ?? "",
      fatherName: json['fatherName'] ?? "",
      pan: json['pan'] ?? "",
      differentlyAbledType: json['differentlyAbledType'] ?? "",
      personalEmailAddress: json['personalEmailAddress'] ?? "",
      addressLine1: json['addressLine1'] ?? "",
      addressLine2: json['addressLine2'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      pinCode: json['pinCode'] ?? "",
    );
  }
}

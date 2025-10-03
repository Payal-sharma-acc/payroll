class EmployeeModellist {
  final int id;
  final String employeeCode;
  final String fullName;
  final String dateOfJoining;
  final String workEmail;
  final String mobileNumber;
  final bool isDirector;
  final String gender;
  final int departmentId;
  final int designationId;
  final int workLocationId;
  final int payScheduleId;
  final bool portalAccessEnabled;

  EmployeeModellist({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.dateOfJoining,
    required this.workEmail,
    required this.mobileNumber,
    required this.isDirector,
    required this.gender,
    required this.departmentId,
    required this.designationId,
    required this.workLocationId,
    required this.payScheduleId,
    required this.portalAccessEnabled,
  });

  factory EmployeeModellist.fromJson(Map<String, dynamic> json) {
    return EmployeeModellist(
      id: json['id'],
      employeeCode: json['employeeCode'],
      fullName: json['fullName'],
      dateOfJoining: json['dateOfJoining'],
      workEmail: json['workEmail'],
      mobileNumber: json['mobileNumber'],
      isDirector: json['isDirector'],
      gender: json['gender'],
      departmentId: json['departmentId'],
      designationId: json['designationId'],
      workLocationId: json['workLocationId'],
      payScheduleId: json['payScheduleId'],
      portalAccessEnabled: json['portalAccessEnabled'],
    );
  }
}

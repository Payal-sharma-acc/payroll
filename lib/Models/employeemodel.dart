class EmployeeModel {
  String? employeeCode;
  String? fullName;
  DateTime? dateOfJoining;
  String? workEmail;
  String? mobileNumber;
  bool? isDirector;
  String? gender;
  int? departmentId;
  int? designationId;
  int? workLocationId;
  int? payScheduleId;
  bool? portalAccessEnabled;
  bool? success;
  String? message;

  EmployeeModel({
    this.employeeCode,
    this.fullName,
    this.dateOfJoining,
    this.workEmail,
    this.mobileNumber,
    this.isDirector,
    this.gender,
    this.departmentId,
    this.designationId,
    this.workLocationId,
    this.payScheduleId,
    this.portalAccessEnabled,
    this.success,
    this.message,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeCode: json['employeeCode'],
      fullName: json['fullName'],
      dateOfJoining: json['dateOfJoining'] != null ? DateTime.parse(json['dateOfJoining']) : null,
      workEmail: json['workEmail'],
      mobileNumber: json['mobileNumber'],
      isDirector: json['isDirector'],
      gender: json['gender'],
      departmentId: json['departmentId'],
      designationId: json['designationId'],
      workLocationId: json['workLocationId'],
      payScheduleId: json['payScheduleId'],
      portalAccessEnabled: json['portalAccessEnabled'],
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeCode': employeeCode,
      'fullName': fullName,
      'dateOfJoining': dateOfJoining?.toIso8601String(),
      'workEmail': workEmail,
      'mobileNumber': mobileNumber,
      'isDirector': isDirector,
      'gender': gender,
      'departmentId': departmentId,
      'designationId': designationId,
      'workLocationId': workLocationId,
      'payScheduleId': payScheduleId,
      'portalAccessEnabled': portalAccessEnabled,
    };
  }
}

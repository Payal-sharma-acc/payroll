class Employeedetailsmodel {
  final int id;
  final String employeeCode;
  final String fullName;
  final DateTime dateOfJoining;
  final String workEmail;
  final String mobileNumber;
  final bool isDirector;
  final String gender;
  final int departmentId;
  final int designationId;
  final int workLocationId;
  final int payScheduleId;
  final int companyId;
  final bool portalAccessEnabled;

  Employeedetailsmodel({
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
    required this.companyId,
    required this.portalAccessEnabled,
  });

  factory Employeedetailsmodel.fromJson(Map<String, dynamic> json) {
    return Employeedetailsmodel(
      id: json['id'],
      employeeCode: json['employeeCode'],
      fullName: json['fullName'],
      dateOfJoining: DateTime.parse(json['dateOfJoining']),
      workEmail: json['workEmail'],
      mobileNumber: json['mobileNumber'],
      isDirector: json['isDirector'],
      gender: json['gender'],
      departmentId: json['departmentId'],
      designationId: json['designationId'],
      workLocationId: json['workLocationId'],
      payScheduleId: json['payScheduleId'],
      companyId: json['companyId'],
      portalAccessEnabled: json['portalAccessEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeCode': employeeCode,
      'fullName': fullName,
      'dateOfJoining': dateOfJoining.toIso8601String(),
      'workEmail': workEmail,
      'mobileNumber': mobileNumber,
      'isDirector': isDirector,
      'gender': gender,
      'departmentId': departmentId,
      'designationId': designationId,
      'workLocationId': workLocationId,
      'payScheduleId': payScheduleId,
      'companyId': companyId,
      'portalAccessEnabled': portalAccessEnabled,
    };
  }
}

class EmployeeLeavegetModel {
  final int applyLeaveId;
  final int employeeId;
  final int companyId;
  final int leaveTypeId;
  final String leaveName;
  final String leaveCode;
  final String fromDate;
  final String toDate;
  final String reason;
  final int status;
 final List<int>? approvedBy;

  final int submittedBy;
  final String createdOn;
  final String updatedOn;

  EmployeeLeavegetModel({
    required this.applyLeaveId,
    required this.employeeId,
    required this.companyId,
    required this.leaveTypeId,
    required this.leaveName,
    required this.leaveCode,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
    required this.approvedBy,
    required this.submittedBy,
    required this.createdOn,
    required this.updatedOn,
  });

  factory EmployeeLeavegetModel.fromJson(Map<String, dynamic> json) {
    return EmployeeLeavegetModel(
      applyLeaveId: json["applyLeaveId"] ?? 0,
      employeeId: json["employeeId"] ?? 0,
      companyId: json["companyId"] ?? 0,
      leaveTypeId: json["leaveTypeId"] ?? 0,
      leaveName: json["leaveName"] ?? "",
      leaveCode: json["leaveCode"] ?? "",
      fromDate: json["fromDate"] ?? "",
      toDate: json["toDate"] ?? "",
      reason: json["reason"] ?? "",
      status: json["status"] ?? "",
    approvedBy: (json['approvedBy'] as List<dynamic>?)?.map((e) => e as int).toList(),

      submittedBy: json["submittedBy"] ?? 0,
      createdOn: json["createdOn"] ?? "",
      updatedOn: json["updatedOn"] ?? "",
    );
  }
}

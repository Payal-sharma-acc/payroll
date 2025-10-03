class EmployeepostLeaveModel {
  final int employeeId;
  final int leaveTypeId;
  final String leaveName;
  final String leaveCode;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
 final int status; 
  final int approvedBy;
  final DateTime createdOn;
  final DateTime updatedOn;
  final List<int> customApproverIds;

  EmployeepostLeaveModel({
    required this.employeeId,
    required this.leaveTypeId,
    required this.leaveName,
    required this.leaveCode,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
    required this.approvedBy,
    required this.createdOn,
    required this.updatedOn,
    required this.customApproverIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "EmployeeId": employeeId,
      "LeaveTypeId": leaveTypeId,
      "LeaveName": leaveName,
      "LeaveCode": leaveCode,
      "FromDate": fromDate.toIso8601String(),
      "ToDate": toDate.toIso8601String(),
      "Reason": reason,
      "Status": status,
      "ApprovedBy": approvedBy,
      "CreatedOn": createdOn.toIso8601String(),
      "UpdatedOn": updatedOn.toIso8601String(),
      "CustomApproverIds": customApproverIds,
    };
  }
}

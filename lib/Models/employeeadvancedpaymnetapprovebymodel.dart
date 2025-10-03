
class ApproverModel {
  final int employeeId;
  final String employeeName;
  final int roleId;
  final String roleName;
  final int sequenceOrder;

  ApproverModel({
    required this.employeeId,
    required this.employeeName,
    required this.roleId,
    required this.roleName,
    required this.sequenceOrder,
  });

  factory ApproverModel.fromJson(Map<String, dynamic> json) {
    return ApproverModel(
      employeeId: json['employeeId'] ?? 0,
      employeeName: json['employeeName'] ?? '',
      roleId: json['roleId'] ?? 0,
      roleName: json['roleName'] ?? '',
      sequenceOrder: json['sequenceOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'roleId': roleId,
      'roleName': roleName,
      'sequenceOrder': sequenceOrder,
    };
  }
}

class EmployeeRoleMappingModel {
  final int ruleId;
  final String requestType;
  final List<ApproverModel> approvers;

  EmployeeRoleMappingModel({
    required this.ruleId,
    required this.requestType,
    required this.approvers,
  });

  factory EmployeeRoleMappingModel.fromJson(Map<String, dynamic> json) {
    return EmployeeRoleMappingModel(
      ruleId: json['ruleId'] ?? 0,
      requestType: json['requestType'] ?? '',
      approvers: (json['approvers'] as List<dynamic>? ?? [])
          .map((e) => ApproverModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ruleId': ruleId,
      'requestType': requestType,
      'approvers': approvers.map((e) => e.toJson()).toList(),
    };
  }
}

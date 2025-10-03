class LeaveTypeModel {
  final int leaveTypeId;
  final String leaveName;
  final String leaveCode;
  final bool isActive;
    final int maxLeavesPerYear;

  LeaveTypeModel({
    required this.leaveTypeId,
    required this.leaveName,
    required this.leaveCode,
    required this.isActive,
        required this.maxLeavesPerYear,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      leaveTypeId: json['leaveTypeId'] ?? 0,
      leaveName: json['leaveName'] ?? '',
      leaveCode: json['leaveCode'] ?? '',
      isActive: json['isActive'] ?? true,
       maxLeavesPerYear: json['maxLeavesPerYear'] ?? 0, 
    );
  }
}

class Employeeleavemodel {
  final int leaveTypeId;
  final String leaveName;
  final String leaveCode;
  final int maxLeavesPerYear;

  Employeeleavemodel({
    required this.leaveTypeId,
    required this.leaveName,
    required this.leaveCode,
    required this.maxLeavesPerYear,
  });

  factory Employeeleavemodel.fromJson(Map<String, dynamic> json) {
    return Employeeleavemodel(
      leaveTypeId: json['leaveTypeId'] ?? 0,
      leaveName: json['leaveName'] ?? '',
      leaveCode: json['leaveCode'] ?? '',
      maxLeavesPerYear: json['maxLeavesPerYear'] ?? 0,
    );
  }
}

class Employeeoutduitymodel {
  final int outDutyId;
  final int employeeId; 
  final DateTime inDateTime;
  final DateTime outDateTime;
  final String reason;
  final String status;
  final int appliedByInt; 

  Employeeoutduitymodel({
    required this.outDutyId,
    required this.employeeId,
    required this.inDateTime,
    required this.outDateTime,
    required this.reason,
    required this.status,
    required this.appliedByInt,
  });

  factory Employeeoutduitymodel.fromJson(Map<String, dynamic> json) {
    return Employeeoutduitymodel(
      outDutyId: json['outDutyId'] ?? 0,
      employeeId: json['employeeId'] ?? 0, 
      inDateTime: DateTime.parse(json['inDateTime']),
      outDateTime: DateTime.parse(json['outDateTime']),
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      appliedByInt: json['appliedByInt'],
    );
  }
}

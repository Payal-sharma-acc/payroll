class Employeepostonduitymodel {
  int? id;
  String? appliedBy;
  DateTime inDateTime;
  DateTime outDateTime;
  String reason;
  String status;
  bool isActive;
  int statusId;

  Employeepostonduitymodel({
    this.id,
    this.appliedBy,
    required this.inDateTime,
    required this.outDateTime,
    required this.reason,
    required this.status,
    this.isActive = true,
    this.statusId = 1, 
  });

  Map<String, dynamic> toJson() {
    return {
      "inDateTime": inDateTime.toIso8601String(),
      "outDateTime": outDateTime.toIso8601String(),
      "reason": reason,
      "isActive": isActive,
      "statusId": statusId,
    };
  }

  factory Employeepostonduitymodel.fromJson(Map<String, dynamic> json) {
    return Employeepostonduitymodel(
      id: json['onDutyID'],
      appliedBy: json['appliedBy'] ?? '',
      inDateTime: DateTime.parse(json['inDateTime']),
      outDateTime: DateTime.parse(json['outDateTime']),
      reason: json['reason'] ?? '',
      status: _getStatusFromId(json['statusId']),
      isActive: json['isActive'] ?? true,
      statusId: json['statusId'] ?? 1,
    );
  }

  static String _getStatusFromId(int statusId) {
    switch (statusId) {
      case 1:
        return "Pending";
      case 5:
        return "Approved";
      case 9:
        return "Rejected";
      default:
        return "Pending";
    }
  }
}

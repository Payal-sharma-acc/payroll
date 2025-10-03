class Employeeattendencepunchoutmodel {
  final int? attendanceId;
  final int? employeeId;
  final String? attendanceDate;
  final String? inTime;
  final String? outTime;
  final String? status;
  final String? workType;
  final int? shiftId;

  Employeeattendencepunchoutmodel({
    this.attendanceId,
    this.employeeId,
    this.attendanceDate,
    this.inTime,
    this.outTime,
    this.status,
    this.workType,
    this.shiftId,
  });

  Map<String, dynamic> toJson() {
    return {
      "attendanceId": attendanceId,
      "employeeId": employeeId,
      "attendanceDate": attendanceDate,
      "inTime": inTime,
      "outTime": outTime,
      "status": status,
      "workType": workType,
      "shiftId": shiftId,
    };
  }

  factory Employeeattendencepunchoutmodel.fromJson(Map<String, dynamic> json) {
    return Employeeattendencepunchoutmodel(
      attendanceId: json['attendanceId'],
      employeeId: json['employeeId'],
      attendanceDate: json['attendanceDate'],
      inTime: json['inTime'],
      outTime: json['outTime'],
      status: json['status'],
      workType: json['workType'],
      shiftId: json['shiftId'],
    );
  }
}

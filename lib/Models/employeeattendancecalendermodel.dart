class Employeeattendancecalendermodel {
  final int attendanceId;
  final int employeeId;
  final DateTime attendanceDate;
  final DateTime? inTime;
  final DateTime? outTime;
  final String? status;
  final String? workType;
  final String? leaveType;
  final bool? halfDay;     

  Employeeattendancecalendermodel({
    required this.attendanceId,
    required this.employeeId,
    required this.attendanceDate,
    this.inTime,
    this.outTime,
    this.status,
    this.workType,
    this.leaveType,
    this.halfDay,
  });

  factory Employeeattendancecalendermodel.fromJson(Map<String, dynamic> json) {
    return Employeeattendancecalendermodel(
      attendanceId: json['attendanceId'] ?? 0,
      employeeId: json['employeeId'] ?? 0,
      attendanceDate: json['attendanceDate'] != null
          ? DateTime.parse(json['attendanceDate'])
          : DateTime.now(),
      inTime: json['inTime'] != null ? DateTime.parse(json['inTime']) : null,
      outTime: json['outTime'] != null ? DateTime.parse(json['outTime']) : null,
      status: json['status'],
      workType: json['workType'],
      leaveType: json['leaveType'],  
      halfDay: json['halfDay'],      
    );
  }
}

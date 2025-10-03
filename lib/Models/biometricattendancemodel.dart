class Biomatricattendancemodel {
  final int? attendanceId;
  final int? employeeId;
  final DateTime? attendanceDate;
  final DateTime? inTime;
  final DateTime? outTime;
  final String? totalHours;
  final String? status;
  final String? workType;
  final int? shiftId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? latitude;  
  final double? longitude;  

  Biomatricattendancemodel({
    this.attendanceId,
    this.employeeId,
    this.attendanceDate,
    this.inTime,
    this.outTime,
    this.totalHours,
    this.status,
    this.workType,
    this.shiftId,
    this.createdAt,
    this.updatedAt,
    this.latitude,   
    this.longitude, 
  });

  factory Biomatricattendancemodel.fromJson(Map<String, dynamic> json) {
    return Biomatricattendancemodel(
      attendanceId: json['attendanceId'],
      employeeId: json['employeeId'],
      attendanceDate: json['attendanceDate'] != null
          ? DateTime.parse(json['attendanceDate'])
          : null,
      inTime: json['inTime'] != null ? DateTime.parse(json['inTime']) : null,
      outTime: json['outTime'] != null ? DateTime.parse(json['outTime']) : null,
      totalHours: json['totalHours']?.toString(),
      status: json['status'],
      workType: json['workType'],
      shiftId: json['shiftId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,  
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'employeeId': employeeId,
      'attendanceDate': attendanceDate?.toIso8601String(),
      'inTime': inTime?.toIso8601String(),
      'outTime': outTime?.toIso8601String(),
      'totalHours': totalHours,
      'status': status,
      'workType': workType,
      'shiftId': shiftId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'latitude': latitude,    
      'longitude': longitude, 
    };
  }
}

class EmployeeHolidayModel {
  final int holidayId;
  final String holidayName;
  final DateTime holidayDate;
  final String holidayType;
  final bool isOptional;
  final bool isRecurring;
  final int workLocationId;
  final bool isActive;
  final bool isRestricted;
  final String description;
  final int createdBy;
  final int? updatedBy;
  final DateTime createdOn;
  final DateTime? updatedOn;

  EmployeeHolidayModel({
    required this.holidayId,
    required this.holidayName,
    required this.holidayDate,
    required this.holidayType,
    required this.isOptional,
    required this.isRecurring,
    required this.workLocationId,
    required this.isActive,
    required this.isRestricted,
    required this.description,
    required this.createdBy,
    this.updatedBy,
    required this.createdOn,
    this.updatedOn,
  });

  factory EmployeeHolidayModel.fromJson(Map<String, dynamic> json) {
    return EmployeeHolidayModel(
      holidayId: json['holidayId'],
      holidayName: json['holidayName'],
      holidayDate: DateTime.parse(json['holidayDate']),
      holidayType: json['holidayType'],
      isOptional: json['isOptional'],
      isRecurring: json['isRecurring'],
      workLocationId: json['workLocationId'],
      isActive: json['isActive'],
      isRestricted: json['isRestricted'],
      description: json['description'] ?? '',
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdOn: DateTime.parse(json['createdOn']),
      updatedOn: json['updatedOn'] != null ? DateTime.parse(json['updatedOn']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'holidayId': holidayId,
      'holidayName': holidayName,
      'holidayDate': holidayDate.toIso8601String(),
      'holidayType': holidayType,
      'isOptional': isOptional,
      'isRecurring': isRecurring,
      'workLocationId': workLocationId,
      'isActive': isActive,
      'isRestricted': isRestricted,
      'description': description,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdOn': createdOn.toIso8601String(),
      'updatedOn': updatedOn?.toIso8601String(),
    };
  }
}

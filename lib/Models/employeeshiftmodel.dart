import 'dart:convert';

class Employeeshiftmodel {
  int? id;
  String shiftName;
  String shiftStart;
  String shiftEnd;
  bool isShiftMarginEnabled;
  String marginBeforeShift;
  String marginAfterShift;
  bool isCoreHoursEnabled;
  String? coreStart;
  String? coreEnd;
  bool isWeekendBasedOnLocation;
  bool hasShiftAllowance;
  double shiftAllowanceAmount;
  List<int> departmentIds;

  Employeeshiftmodel({
    this.id,
    required this.shiftName,
    required this.shiftStart,
    required this.shiftEnd,
    required this.isShiftMarginEnabled,
    required this.marginBeforeShift,
    required this.marginAfterShift,
    required this.isCoreHoursEnabled,
    this.coreStart,
    this.coreEnd,
    required this.isWeekendBasedOnLocation,
    required this.hasShiftAllowance,
    required this.shiftAllowanceAmount,
    required this.departmentIds,
  });

  factory Employeeshiftmodel.fromJson(Map<String, dynamic> json) => Employeeshiftmodel(
        id: json['id'],
        shiftName: json['shiftName'],
        shiftStart: json['shiftStart'],
        shiftEnd: json['shiftEnd'],
        isShiftMarginEnabled: json['isShiftMarginEnabled'],
        marginBeforeShift: json['marginBeforeShift'],
        marginAfterShift: json['marginAfterShift'],
        
        isCoreHoursEnabled: json['isCoreHoursEnabled'],
        coreStart: json['coreStart'],
        coreEnd: json['coreEnd'],
        isWeekendBasedOnLocation: json['isWeekendBasedOnLocation'],
        hasShiftAllowance: json['hasShiftAllowance'],
        shiftAllowanceAmount: (json['shiftAllowanceAmount'] ?? 0).toDouble(),
        departmentIds: List<int>.from(json['departmentIds'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'shiftName': shiftName,
        'shiftStart': shiftStart,
        'shiftEnd': shiftEnd,
        'isShiftMarginEnabled': isShiftMarginEnabled,
        'marginBeforeShift': marginBeforeShift,
        'marginAfterShift': marginAfterShift,
        'isCoreHoursEnabled': isCoreHoursEnabled,
        'coreStart': coreStart,
        'coreEnd': coreEnd,
        'isWeekendBasedOnLocation': isWeekendBasedOnLocation,
        'hasShiftAllowance': hasShiftAllowance,
        'shiftAllowanceAmount': shiftAllowanceAmount,
        'departmentIds': departmentIds,
      };
}

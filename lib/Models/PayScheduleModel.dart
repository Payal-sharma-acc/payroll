class PayScheduleModel {
  final String name;
  final List<String> workWeekDays;
  final String salaryBasedOn;
  final int organizationWorkingDays;
  final String payOnType;
  final int specificPayDay;
  final DateTime firstPayrollStartFrom;
  final String payFrequency;

  PayScheduleModel({
    required this.name,
    required this.workWeekDays,
    required this.salaryBasedOn,
    required this.organizationWorkingDays,
    required this.payOnType,
    required this.specificPayDay,
    required this.firstPayrollStartFrom,
    required this.payFrequency,
  });

  factory PayScheduleModel.fromJson(Map<String, dynamic> json) {
    return PayScheduleModel(
      name: json['name'] as String,
      workWeekDays: List<String>.from(json['workWeekDays'] ?? []),
      salaryBasedOn: json['salaryBasedOn'] as String,
      organizationWorkingDays: json['organizationWorkingDays'] as int,
      payOnType: json['payOnType'] as String,
      specificPayDay: json['specificPayDay'] as int,
      firstPayrollStartFrom: DateTime.parse(json['firstPayrollStartFrom']),
      payFrequency: json['payFrequency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'workWeekDays': workWeekDays,
      'salaryBasedOn': salaryBasedOn,
      'organizationWorkingDays': organizationWorkingDays,
      'payOnType': payOnType,
      'specificPayDay': specificPayDay,
      'firstPayrollStartFrom': firstPayrollStartFrom.toIso8601String(),
      'payFrequency': payFrequency,
    };
  }
}

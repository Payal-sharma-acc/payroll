class Payseduleaddemployeemodel {
  int? id;
  String? name;
  List<String>? workWeekDays;
  String? salaryBasedOn;
  int? organizationWorkingDays;
  String? payOnType;
  int? specificPayDay;
  DateTime? firstPayrollStartFrom;
  String? payFrequency;
  int? companyId;
  int? createdBy;

  Payseduleaddemployeemodel({
    this.id,
    this.name,
    this.workWeekDays,
    this.salaryBasedOn,
    this.organizationWorkingDays,
    this.payOnType,
    this.specificPayDay,
    this.firstPayrollStartFrom,
    this.payFrequency,
    this.companyId,
    this.createdBy,
  });

  factory Payseduleaddemployeemodel.fromJson(Map<String, dynamic> json) {
    return Payseduleaddemployeemodel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      workWeekDays: json['workWeekDays'] != null
          ? List<String>.from(json['workWeekDays'])
          : [],
      salaryBasedOn: json['salaryBasedOn'] as String?,
      organizationWorkingDays: json['organizationWorkingDays'] as int?,
      payOnType: json['payOnType'] as String?,
      specificPayDay: json['specificPayDay'] as int?,
      firstPayrollStartFrom: json['firstPayrollStartFrom'] != null
          ? DateTime.parse(json['firstPayrollStartFrom'])
          : null,
      payFrequency: json['payFrequency'] as String?,
      companyId: json['companyId'] as int?,
      createdBy: json['createdBy'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'workWeekDays': workWeekDays,
      'salaryBasedOn': salaryBasedOn,
      'organizationWorkingDays': organizationWorkingDays,
      'payOnType': payOnType,
      'specificPayDay': specificPayDay,
      'firstPayrollStartFrom': firstPayrollStartFrom?.toIso8601String(),
      'payFrequency': payFrequency,
      'companyId': companyId,
      'createdBy': createdBy,
    };
  }
}

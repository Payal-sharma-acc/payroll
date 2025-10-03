class Salarydetailcreatemodel {
  int? employeeId;
  int? orgId;
  int? month;
  int? year;
  int? employeeCategory;
  double? basicSalary;
  double? hra;
  double? conveyanceAllowance;
  double? fixedAllowance;
  double? bonus;
  double? arrears;
  double? overtimeHours;
  double? overtimeRate;
  double? leaveEncashment;
  double? specialAllowance;
  double? pfEmployee;
  double? esicEmployee;
  double? professionalTax;
  double? tds;
  double? loanRepayment;
  double? otherDeductions;
  int? absentDays;
  int? totalWorkingDays;
  int? status;
  DateTime? paymentDate;
  int? componentConfigId;
  String? componentName;
  int? calculationType;
  double? percentageValue;
  double? fixedAmount;
  double monthly;
  double annual;

  Salarydetailcreatemodel({
    this.employeeId,
    this.orgId,
    this.month,
    this.year,
    this.employeeCategory,
    this.basicSalary,
    this.hra,
    this.conveyanceAllowance,
    this.fixedAllowance,
    this.bonus,
    this.arrears,
    this.overtimeHours,
    this.overtimeRate,
    this.leaveEncashment,
    this.specialAllowance,
    this.pfEmployee,
    this.esicEmployee,
    this.professionalTax,
    this.tds,
    this.loanRepayment,
    this.otherDeductions,
    this.absentDays,
    this.totalWorkingDays,
    this.status,
    this.paymentDate,
    this.componentConfigId,
    this.componentName,
    this.calculationType,
    this.percentageValue,
    this.fixedAmount,
    this.monthly = 0,
    this.annual = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "employeeId": employeeId,
      "orgId": orgId,
      "month": month,
      "year": year,
      "employeeCategory": employeeCategory,
      "basicSalary": basicSalary,
      "hra": hra,
      "conveyanceAllowance": conveyanceAllowance,
      "fixedAllowance": fixedAllowance,
      "bonus": bonus,
      "arrears": arrears,
      "overtimeHours": overtimeHours,
      "overtimeRate": overtimeRate,
      "leaveEncashment": leaveEncashment,
      "specialAllowance": specialAllowance,
      "pfEmployee": pfEmployee,
      "esicEmployee": esicEmployee,
      "professionalTax": professionalTax,
      "tds": tds,
      "loanRepayment": loanRepayment,
      "otherDeductions": otherDeductions,
      "absentDays": absentDays,
      "totalWorkingDays": totalWorkingDays,
      "status": status,
      "paymentDate": paymentDate?.toIso8601String(),
    };
  }
}

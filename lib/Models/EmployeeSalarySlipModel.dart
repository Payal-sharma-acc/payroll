class EmployeeSalarySlipModel {
  final int employeeSalarySlipId;
  final String? payPeriod;
  final DateTime payDate;
  final List<Employee> employees;
  final List<Department> department;
  final List<WorkLocation> workLocations;
  final List<BankDetail> bankDetail;
  final List<SalaryDetail> salaryDetail;

  EmployeeSalarySlipModel({
    required this.employeeSalarySlipId,
    required this.payPeriod,
    required this.payDate,
    required this.employees,
    required this.department,
    required this.workLocations,
    required this.bankDetail,
    required this.salaryDetail,
  });

  factory EmployeeSalarySlipModel.fromJson(Map<String, dynamic> json) {
    return EmployeeSalarySlipModel(
      employeeSalarySlipId: json['employeeSalarySlipId'],
      payPeriod: json['payPeriod'],
      payDate: DateTime.parse(json['payDate']),
      employees: (json['employees'] as List)
          .map((e) => Employee.fromJson(e))
          .toList(),
      department: (json['department'] as List)
          .map((d) => Department.fromJson(d))
          .toList(),
      workLocations: (json['workLocations'] as List)
          .map((w) => WorkLocation.fromJson(w))
          .toList(),
      bankDetail: (json['bankDetail'] as List)
          .map((b) => BankDetail.fromJson(b))
          .toList(),
      salaryDetail: (json['salaryDetail'] as List)
          .map((s) => SalaryDetail.fromJson(s))
          .toList(),
    );
  }
}

class Employee {
  final int id;
  final String employeeCode;
  final String fullName;
  final DateTime dateOfJoining;
  final String workEmail;

  Employee({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.dateOfJoining,
    required this.workEmail,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      employeeCode: json['employeeCode'],
      fullName: json['fullName'],
      dateOfJoining: DateTime.parse(json['dateOfJoining']),
      workEmail: json['workEmail'],
    );
  }
}

class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
    );
  }
}

class WorkLocation {
  final int id;
  final String name;

  WorkLocation({required this.id, required this.name});

  factory WorkLocation.fromJson(Map<String, dynamic> json) {
    return WorkLocation(
      id: json['id'],
      name: json['name'],
    );
  }
}

class BankDetail {
  BankDetail();

  factory BankDetail.fromJson(Map<String, dynamic> json) {
    return BankDetail();
  }
}

class SalaryDetail {
  final int salaryId;
  final int employeeId;
  final double hra;
  final double basicSalary;
  final double fixedAllowance;
  final double bonus;
  final double arrears;
  final double overtimeHours;
  final double overtimeRate;
  final double overtimeAmount;
  final double leaveEncashment;
  final double specialAllowance;
  final double earnings;
  final double conveyanceAllowance;
  final double otherAllowances;
  final double deductions;
  final double netPay;
  final int totalWorkingDays;
  final DateTime paymentDate;

  SalaryDetail({
    required this.salaryId,
    required this.employeeId,
    required this.hra,
    required this.basicSalary,
    required this.fixedAllowance,
    required this.bonus,
    required this.arrears,
    required this.overtimeHours,
    required this.overtimeRate,
    required this.overtimeAmount,
    required this.leaveEncashment,
    required this.specialAllowance,
    required this.earnings,
    required this.conveyanceAllowance,
    required this.otherAllowances,
    required this.deductions,
    required this.netPay,
    required this.totalWorkingDays,
    required this.paymentDate,
  });

  factory SalaryDetail.fromJson(Map<String, dynamic> json) {
    return SalaryDetail(
      salaryId: json['salaryId'],
      employeeId: json['employeeId'],
      hra: (json['hra'] as num).toDouble(),
      basicSalary: (json['basicSalary'] as num).toDouble(),
      fixedAllowance: (json['fixedAllowance'] as num).toDouble(),
      bonus: (json['bonus'] as num).toDouble(),
      arrears: (json['arrears'] as num).toDouble(),
      overtimeHours: (json['overtimeHours'] as num).toDouble(),
      overtimeRate: (json['overtimeRate'] as num).toDouble(),
      overtimeAmount: (json['overtimeAmount'] as num).toDouble(),
      leaveEncashment: (json['leaveEncashment'] as num).toDouble(),
      specialAllowance: (json['specialAllowance'] as num).toDouble(),
      earnings: (json['earnings'] as num).toDouble(),
      conveyanceAllowance: (json['conveyanceAllowance'] as num).toDouble(),
      otherAllowances: (json['otherAllowances'] as num).toDouble(),
      deductions: (json['deductions'] as num).toDouble(),
      netPay: (json['netPay'] as num).toDouble(),
      totalWorkingDays: json['totalWorkingDays'],
      paymentDate: DateTime.parse(json['paymentDate']),
    );
  }
}

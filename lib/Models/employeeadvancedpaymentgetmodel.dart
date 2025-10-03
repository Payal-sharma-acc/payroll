class EmployeeAdvancePaymentgetmodel {
  final int advancePaymentId;
  final int employeeId;
  final double advancePaymentAmount;
  final String advancePaymentType;
  final int noOfInstallments;
  final double installmentAmount;
  final DateTime repaymentStartDate;
  final DateTime? repaymentEndDate;
  final double amountRepaid;
  final double balanceAmount;
  final bool isFullyRepaid;
  final int statusId;
  final String? reason;
  final String? comments;
  final List<int>? approvedBy;

  final int submittedBy;
  final DateTime createdOn;
  final DateTime? updatedOn;
  final bool isActive;
  final List<Installment> installments;

  EmployeeAdvancePaymentgetmodel({
    required this.advancePaymentId,
    required this.employeeId,
    required this.advancePaymentAmount,
    required this.advancePaymentType,
    required this.noOfInstallments,
    required this.installmentAmount,
    required this.repaymentStartDate,
    this.repaymentEndDate,
    required this.amountRepaid,
    required this.balanceAmount,
    required this.isFullyRepaid,
    required this.statusId,
    this.reason,
    this.comments,
    this.approvedBy,
    required this.submittedBy,
    required this.createdOn,
    this.updatedOn,
    required this.isActive,
    required this.installments,
  });

  factory EmployeeAdvancePaymentgetmodel.fromJson(Map<String, dynamic> json) {
    return EmployeeAdvancePaymentgetmodel(
      advancePaymentId: json['advancePaymentId'],
      employeeId: json['employeeId'],
      advancePaymentAmount: (json['advancePaymentAmount'] ?? 0).toDouble(),
      advancePaymentType: json['advancePaymentType'] ?? '',
      noOfInstallments: json['noOfInstallments'] ?? 0,
      installmentAmount: (json['installmentAmount'] ?? 0).toDouble(),
      repaymentStartDate: DateTime.parse(json['repaymentStartDate']),
      repaymentEndDate: json['repaymentEndDate'] != null ? DateTime.parse(json['repaymentEndDate']) : null,
      amountRepaid: (json['amountRepaid'] ?? 0).toDouble(),
      balanceAmount: (json['balanceAmount'] ?? 0).toDouble(),
      isFullyRepaid: json['isFullyRepaid'] ?? false,
      statusId: json['statusId'] ?? 0,
      reason: json['reason'],
      comments: json['comments'],
      approvedBy: (json['approvedBy'] as List<dynamic>?)?.map((e) => e as int).toList(),

      submittedBy: json['submittedBy'] ?? 0,
      createdOn: DateTime.parse(json['createdOn']),
      updatedOn: json['updatedOn'] != null ? DateTime.parse(json['updatedOn']) : null,
      isActive: json['isActive'] ?? false,
      installments: (json['installments'] as List<dynamic>? ?? [])
          .map((e) => Installment.fromJson(e))
          .toList(),
    );
  }
}

class Installment {
  final int installmentId;
  final int advancePaymentId;
  final int installmentNumber;
  final double installmentAmount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final double paidAmount;
  final int statusId;
  final String? comments;
  final DateTime createdOn;
  final DateTime? updatedOn;
  final bool isActive;

  Installment({
    required this.installmentId,
    required this.advancePaymentId,
    required this.installmentNumber,
    required this.installmentAmount,
    required this.dueDate,
    this.paidDate,
    required this.paidAmount,
    required this.statusId,
    this.comments,
    required this.createdOn,
    this.updatedOn,
    required this.isActive,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      installmentId: json['installmentId'],
      advancePaymentId: json['advancePaymentId'],
      installmentNumber: json['installmentNumber'],
      installmentAmount: (json['installmentAmount'] ?? 0).toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      statusId: json['statusId'] ?? 0,
      comments: json['comments'],
      createdOn: DateTime.parse(json['createdOn']),
      updatedOn: json['updatedOn'] != null ? DateTime.parse(json['updatedOn']) : null,
      isActive: json['isActive'] ?? false,
    );
  }
}

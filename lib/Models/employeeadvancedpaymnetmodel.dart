class Employeeadvancedpaymentmodel {
  int employeeId;
  double advancePaymentAmount;
  String advancePaymentType;
  int noOfInstallments;
  double installmentAmount;
  DateTime repaymentStartDate;
  String reason;
  String comments;
  List<int> customApproverIds;

  Employeeadvancedpaymentmodel({
    required this.employeeId,
    required this.advancePaymentAmount,
    required this.advancePaymentType,
    required this.noOfInstallments,
    required this.installmentAmount,
    required this.repaymentStartDate,
    required this.reason,
    required this.comments,
    required this.customApproverIds,
  });

  factory Employeeadvancedpaymentmodel.fromJson(Map<String, dynamic> json) {
    return Employeeadvancedpaymentmodel(
      employeeId: json['employeeId'] ?? 0,
      advancePaymentAmount: (json['advancePaymentAmount'] ?? 0).toDouble(),
      advancePaymentType: json['advancePaymentType'] ?? '',
      noOfInstallments: json['noOfInstallments'] ?? 0,
      installmentAmount: (json['installmentAmount'] ?? 0).toDouble(),
      repaymentStartDate: DateTime.parse(json['repaymentStartDate'] ?? DateTime.now().toIso8601String()),
      reason: json['reason'] ?? '',
      comments: json['comments'] ?? '',
      customApproverIds: List<int>.from(json['customApproverIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "employeeId": employeeId,
      "advancePaymentAmount": advancePaymentAmount,
      "advancePaymentType": advancePaymentType,
      "noOfInstallments": noOfInstallments,
      "installmentAmount": installmentAmount,
      "repaymentStartDate": repaymentStartDate.toIso8601String(),
      "reason": reason,
      "comments": comments,
      "customApproverIds": customApproverIds,
    };
  }
}

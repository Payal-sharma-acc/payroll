class Salaryconfigupdatemodel {
  int componentConfigId;
  int orgId;
  String componentName;
  bool isEnabled;
  int calculationType;
  double percentageValue;
  double fixedAmount;

  Salaryconfigupdatemodel({
    required this.componentConfigId,
    required this.orgId,
    required this.componentName,
    required this.isEnabled,
    required this.calculationType,
    required this.percentageValue,
    required this.fixedAmount,
  });

  factory Salaryconfigupdatemodel.fromJson(Map<String, dynamic> json) {
    return Salaryconfigupdatemodel(
      componentConfigId: json['componentConfigId'] ?? 0,
      orgId: json['orgId'] ?? 0,
      componentName: json['componentName'] ?? '',
      isEnabled: json['isEnabled'] ?? false,
      calculationType: json['calculationType'] ?? 0,
      percentageValue: (json['percentageValue'] ?? 0).toDouble(),
      fixedAmount: (json['fixedAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'componentConfigId': componentConfigId,
      'orgId': orgId,
      'componentName': componentName,
      'isEnabled': isEnabled,
      'calculationType': calculationType,
      'percentageValue': percentageValue,
      'fixedAmount': fixedAmount,
    };
  }
}

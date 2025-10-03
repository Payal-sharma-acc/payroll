class Salaryconfiggetmodel {
  final int componentConfigId;
  final int orgId;
  final String componentName;
  final bool isEnabled;
  final int calculationType;  
  final double percentageValue;
  final double fixedAmount;
  final bool isDeduction;

  Salaryconfiggetmodel({
    required this.componentConfigId,
    required this.orgId,
    required this.componentName,
    required this.isEnabled,
    required this.calculationType,
    required this.percentageValue,
    required this.fixedAmount,
    required this.isDeduction
  });

  factory Salaryconfiggetmodel.fromJson(Map<String, dynamic> json) {
    return Salaryconfiggetmodel(
      componentConfigId: json['componentConfigId'] ?? 0,
      orgId: json['orgId'] ?? 0,
      componentName: json['componentName'] ?? '',
      isEnabled: json['isEnabled'] ?? false,
      calculationType: json['calculationType'] ?? 1,
      percentageValue: (json['percentageValue'] as num?)?.toDouble() ?? 0.0,
      fixedAmount: (json['fixedAmount'] as num?)?.toDouble() ?? 0.0,
      isDeduction: json['isDeduction'] ?? false,
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
    'isDeduction': isDeduction, 
  };
}

}

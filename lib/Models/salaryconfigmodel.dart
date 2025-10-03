class Salaryconfigmodel {
  final int? componentConfigId;
  final int orgId;
  final String componentName;
  final bool isEnabled;
  final int calculationType;
  final double? percentageValue;
  final double? fixedAmount;

  Salaryconfigmodel({
    this.componentConfigId,
    required this.orgId,
    required this.componentName,
    required this.isEnabled,
    required this.calculationType,
    this.percentageValue,
    this.fixedAmount,
  });
  factory Salaryconfigmodel.fromJson(Map<String, dynamic> json) {
    return Salaryconfigmodel(
      componentConfigId: json['componentConfigId'] as int?,
      orgId: json['orgId'] as int,
      componentName: json['componentName'] as String,
      isEnabled: json['isEnabled'] as bool,
      calculationType: json['calculationType'] as int,
      percentageValue: json['percentageValue']?.toDouble(),
      fixedAmount: json['fixedAmount']?.toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      if (componentConfigId != null) 'componentConfigId': componentConfigId,
      'orgId': orgId,
      'componentName': componentName,
      'isEnabled': isEnabled,
      'calculationType': calculationType,
      if (percentageValue != null) 'percentageValue': percentageValue,
      if (fixedAmount != null) 'fixedAmount': fixedAmount,
    };
  }
}
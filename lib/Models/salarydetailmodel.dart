class SalaryComponent {
  final int componentConfigId;
  final String componentName;
  final int calculationType;
  double percentageValue;
  double monthly;
  double annual;
  double fixedAmount;

  SalaryComponent({
    required this.componentConfigId,
    required this.componentName,
    required this.calculationType,
    this.percentageValue = 0,
    this.monthly = 0,
    this.annual = 0,
    this.fixedAmount = 0,
  });

  factory SalaryComponent.fromJson(Map<String, dynamic> json, double basicSalary) {
    double monthly = 0;
    if (json["calculationType"] == 1) {
      monthly = (basicSalary * (json["percentageValue"] ?? 0)) / 100;
    } else {
      monthly = (json["fixedAmount"] ?? 0).toDouble();
    }
    return SalaryComponent(
      componentConfigId: json["componentConfigId"],
      componentName: json["componentName"],
      calculationType: json["calculationType"],
      percentageValue: (json["percentageValue"] ?? 0).toDouble(),
      fixedAmount: (json["fixedAmount"] ?? 0).toDouble(),
      monthly: monthly,
      annual: monthly * 12,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "componentConfigId": componentConfigId,
      "componentName": componentName,
      "calculationType": calculationType,
      "percentageValue": percentageValue,
      "fixedAmount": fixedAmount,
      "monthly": monthly,
      "annual": annual,
    };
  }

  void copyWith({required double fixedAmount, required double monthly, required double annual}) {}
}
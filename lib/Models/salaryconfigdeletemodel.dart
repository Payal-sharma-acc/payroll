class SalaryConfigDeleteModel {
  final String message;
  final bool success;

  SalaryConfigDeleteModel({required this.message, this.success = false});

  factory SalaryConfigDeleteModel.fromJson(Map<String, dynamic> json) {
    return SalaryConfigDeleteModel(
      message: json['message'] ?? 'No message provided',
      success: json['success'] ?? false,
    );
  }
}
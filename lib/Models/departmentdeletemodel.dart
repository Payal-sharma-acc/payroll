class DepartmentDeleteModel {
  final String message;

  DepartmentDeleteModel({required this.message});

  factory DepartmentDeleteModel.fromJson(Map<String, dynamic> json) {
    return DepartmentDeleteModel(
      message: json['message'] ?? 'No message returned',
    );
  }
}


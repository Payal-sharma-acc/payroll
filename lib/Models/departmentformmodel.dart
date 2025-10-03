class Departmentformmodel {
  final String name;
  final String description;
  final int? id;
  final String? message;
  final int? adminUserId;

  Departmentformmodel({
    required this.name,
    required this.description,
    this.id,
    this.message,
    this.adminUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  factory Departmentformmodel.fromJson(Map<String, dynamic> json) {
    return Departmentformmodel(
      name: json['name'] != null ? json['name'] as String : '',
      description: json['description'] != null ? json['description'] as String : '',
      id: json['id'] != null ? json['id'] as int : null,
      message: json['message'] != null ? json['message'] as String : null,
      adminUserId: json['adminUserId'] != null ? json['adminUserId'] as int : null,
    );
  }
}

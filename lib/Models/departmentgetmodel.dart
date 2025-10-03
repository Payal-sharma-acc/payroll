class Departmentgetmodel {
  final int id;
  final String name;
  final String description;

  Departmentgetmodel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Departmentgetmodel.fromJson(Map<String, dynamic> json) {
    return Departmentgetmodel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

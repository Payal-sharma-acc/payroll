class Departmentupdatemodel {
  final String message;
  final int id;
  final String name; 
  final String description; 

  Departmentupdatemodel({
    required this.message,
    required this.id,
    required this.name,
    required this.description,
  });

  factory Departmentupdatemodel.fromJson(Map<String, dynamic> json) {
    return Departmentupdatemodel(
      message: json['message'] ?? "",
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
    );
  }
}

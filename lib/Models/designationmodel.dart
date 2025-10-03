class designationmodel {
  final int id;
  final String title;
  final String level;

  designationmodel({
    required this.id,
    required this.title,
    required this.level,
  });

  factory designationmodel.fromJson(Map<String, dynamic> json) {
    return designationmodel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'level': level,
    };
  }
}

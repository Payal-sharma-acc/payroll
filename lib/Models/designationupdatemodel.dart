class Designationupdatemodel {
  int id;
  String title;
  String level;

  Designationupdatemodel({required this.id, required this.title, required this.level});

  factory Designationupdatemodel.fromJson(Map<String, dynamic> json) {
    return Designationupdatemodel(
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

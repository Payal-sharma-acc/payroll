class DesignationImportModel {
  final String title;
  final String level;

  DesignationImportModel({
    required this.title,
    required this.level,
  });

  factory DesignationImportModel.fromJson(Map<String, dynamic> json) {
    return DesignationImportModel(
      title: json['title'] ?? '',
      level: json['level'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'level': level,
    };
  }
}

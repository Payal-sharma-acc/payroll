class designationPostModel {
  String title;
  String level;

  designationPostModel({required this.title, required this.level});
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'level': level,
    };
  }
  factory designationPostModel.fromJson(Map<String, dynamic> json) {
    return designationPostModel(
      title: json['title'] ?? '',
      level: json['level'] ?? '',
    );
  }
}

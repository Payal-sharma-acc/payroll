class Permissiongetmodel {
  final String moduleName;
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;

  Permissiongetmodel({
    required this.moduleName,
    required this.canView,
    required this.canCreate,
    required this.canEdit,
    required this.canDelete,
  });

  factory Permissiongetmodel.fromJson(Map<String, dynamic> json) {
    return Permissiongetmodel(
      moduleName: json['moduleName'],
      canView: json['canView'],
      canCreate: json['canCreate'],
      canEdit: json['canEdit'],
      canDelete: json['canDelete'],
    );
  }
}

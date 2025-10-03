class Permissionmodel {
  final int adminUserId;
  final String moduleName;
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;

  Permissionmodel({
    required this.adminUserId,
    required this.moduleName,
    required this.canView,
    required this.canCreate,
    required this.canEdit,
    required this.canDelete,
  });

  Map<String, dynamic> toJson() {
    return {
      "adminUserId": adminUserId,
      "moduleName": moduleName,
      "canView": canView,
      "canCreate": canCreate,
      "canEdit": canEdit,
      "canDelete": canDelete,
    };
  }
}

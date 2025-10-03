class StatusMasterModel {
  final int statusId;
  final int companyId;
  final String statusName;
  final String statusCode;
  final String createdBy;
  final DateTime createdOn;
  final bool isActive;

  StatusMasterModel({
    required this.statusId,
    required this.companyId,
    required this.statusName,
    required this.statusCode,
    required this.createdBy,
    required this.createdOn,
    required this.isActive,
  });

  factory StatusMasterModel.fromJson(Map<String, dynamic> json) {
    return StatusMasterModel(
      statusId: json['statusId'] ?? 0,
      companyId: json['companyId'] ?? 0,
      statusName: json['statusName'] ?? "",
      statusCode: json['statusCode'] ?? "",
      createdBy: json['createdBy'] ?? "",
      createdOn: DateTime.tryParse(json['createdOn'] ?? "") ?? DateTime.now(),
      isActive: json['isActive'] ?? false,
    );
  }
}

class Companynamepopupmodel {
  int? companyId;
  String companyName;
  String companyCode;
  String? createdBy;
  String? createdAt;
  String? token;
  Companynamepopupmodel.create({
    required this.companyName,
    required this.companyCode,
  });
  Companynamepopupmodel({
    required this.companyId,
    required this.companyName,
    required this.companyCode,
    required this.createdBy,
    required this.createdAt,
    required this.token,
  });
  Map<String, dynamic> toJson() => {
        "companyName": companyName,
        "companyCode": companyCode,
      };
        factory Companynamepopupmodel.fromJson(Map<String, dynamic> json) =>
      Companynamepopupmodel(
        companyId: json["companyId"] ?? 0,
        companyName: json["companyName"] ?? "",
        companyCode: json["companyCode"] ?? "",
        createdBy: json["createdBy"] ?? "",
        createdAt: json["createdAt"] ?? "",
        token: json["token"] ?? "",
      );
}

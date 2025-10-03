class Employeeleaveapprovedbymodel {
  final int id;
  final String fullName;
  final String workEmail;

  Employeeleaveapprovedbymodel({
    required this.id,
    required this.fullName,
    required this.workEmail,
  });

  factory Employeeleaveapprovedbymodel.fromJson(Map<String, dynamic> json) {
    return Employeeleaveapprovedbymodel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      workEmail: json['workEmail'] ?? '',
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employeeleaveapprovedbymodel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => fullName; 
}

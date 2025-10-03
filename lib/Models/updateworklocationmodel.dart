class updateworklocationmodel {
  final String id;
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String state;
  final String city;
  final String pinCode;

  updateworklocationmodel({
    required this.id,
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    required this.state,
    required this.city,
    required this.pinCode,
  });

  factory updateworklocationmodel.fromJson(Map<String, dynamic> json) {
    return updateworklocationmodel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['pinCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'state': state,
      'city': city,
      'pinCode': pinCode,
    };
  }
}

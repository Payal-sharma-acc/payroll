class Worklocationgetmodel {
  final String id;
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String state;
  final String city;
  final String pinCode;

  Worklocationgetmodel({
    required this.id,
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    required this.state,
    required this.city,
    required this.pinCode,
  });

  factory Worklocationgetmodel.fromJson(Map<String, dynamic> json) {
    return Worklocationgetmodel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['pinCode'] ?? '',
    );
  }
}

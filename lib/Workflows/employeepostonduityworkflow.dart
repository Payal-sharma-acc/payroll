import 'dart:convert';
import 'package:payrollapp/Models/employeeoutduitymodel.dart';
import 'package:payrollapp/api_client.dart';

class Employeepostonduityworkflow {
  static Future<void> createOutDuty(Map<String, dynamic> data) async {
    final response = await ApiClient.post(
      "/api/OnDuty",
      body: jsonEncode(data),
    );
    print("Request JSON: ${jsonEncode(data)}");
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Out Duty submitted successfully");
    } else {
      throw Exception("Failed: ${response.body}");
    }
  }
}

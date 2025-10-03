import 'dart:convert';
import 'package:payrollapp/Models/employeeprofilemodel.dart';
import 'package:payrollapp/api_client.dart';

class Employeeprofileworkflow {
  Future<Employeeprofilemodel> getPersonalDetails(int employeeId) async {
    final response = await ApiClient.get("/api/PersonalDetails/$employeeId");
    print("📥 PersonalDetails Response Code: ${response.statusCode}");
    print("📥 PersonalDetails Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Employeeprofilemodel.fromJson(data);
    } else {
      throw Exception("Failed to load personal details: ${response.body}");
    }
  }
}

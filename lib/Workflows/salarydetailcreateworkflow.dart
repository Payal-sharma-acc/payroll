import 'dart:convert';
import 'package:payrollapp/Models/salarydetailcreatemodel.dart';
import 'package:payrollapp/api_client.dart';


class Salarydetailcreateworkflow {
  static Future<Map<String, dynamic>?> createSalary(Salarydetailcreatemodel salary) async {
    try {
      final response = await ApiClient.post(
        "/Salary/create",
        body: jsonEncode(salary.toJson()),
      );
      print("Raw API Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        print("Decoded API Response: $decoded");
        return decoded;
      } else {
        print("Failed to create salary: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error in createSalary: $e");
      return null;
    }
  }
}

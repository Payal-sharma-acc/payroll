import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/salarydetailmodel.dart';
import 'package:payrollapp/utils/token_storage.dart';

class Salarydetailworkflow {
  final String baseUrl = "https://digipaystaggingapi.digicodesoftware.com";
  Future<List<SalaryComponent>> fetchComponents({
    required String orgId,
    required int employeeId,
    required int month,
    required int year,
    double basicSalary = 0,
  }) async {
    try {
      final token = await TokenStorage.getToken();

      final url =
          "$baseUrl/api/EmployeeSalarySlip/get?employeeId=$employeeId&orgId=$orgId&month=$month&year=$year";

      print("🔹 Fetching Salary Slip: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: token != null
            ? {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json'
              }
            : {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> data = jsonBody["data"] ?? [];

        return data.map((c) => SalaryComponent.fromJson(c, basicSalary)).toList();
      } else {
        print("❌ Failed to fetch salary components: ${response.statusCode}");
        print("Response body: ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ Exception fetching salary components: $e");
      return [];
    }
  }
  Future<bool> saveSalaryDetails(Map<String, dynamic> payload) async {
    try {
      final token = await TokenStorage.getToken();

      final response = await http.post(
        Uri.parse("$baseUrl/api/EmployeeSalarySlip/save"),
        headers: token != null
            ? {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json'
              }
            : {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("Save salary status: ${response.statusCode}");
      print("Save salary response: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Exception saving salary details: $e");
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/employeeadvancedpaymentgetmodel.dart';
import 'package:payrollapp/utils/token_storage.dart';

class EmployeeAdvancePaymentgetWorkflow {
  static const String baseUrl =
      "https://digipaystaggingapi.digicodesoftware.com";

  static Future<List<EmployeeAdvancePaymentgetmodel>> getAdvancePayments(
    int employeeId,
  ) async {
    try {
      final token = await TokenStorage.getToken();
      final orgId =
          await TokenStorage.getOrgId(); 
      final url = Uri.parse(
        '$baseUrl/api/AdvancePayment/employee/$employeeId?orgId=$orgId',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'OrgId': orgId.toString(), 
        },
      );

      print("🔹 API Status: ${response.statusCode}");
      print("🔹 API Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonBody['data'] ?? [];

        return jsonData
            .map((item) => EmployeeAdvancePaymentgetmodel.fromJson(item))
            .toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
          "Failed to fetch Advance Payments: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("❌ Exception in getAdvancePaymentsByEmployee: $e");
      throw Exception("Failed to fetch Advance Payments");
    }
  }
}

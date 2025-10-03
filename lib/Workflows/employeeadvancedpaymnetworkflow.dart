import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/employeeadvancedpaymnetmodel.dart';
import 'package:payrollapp/utils/token_storage.dart';

class EmployeeAdvancedPaymentWorkflow {
  static const String baseUrl = "https://digipaystaggingapi.digicodesoftware.com";
  static Future<bool> createAdvancePayment(Employeeadvancedpaymentmodel model) async {
    try {
      final url = Uri.parse('$baseUrl/api/AdvancePayment');
      final body = jsonEncode(model.toJson());
      final token = await TokenStorage.getToken();

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Advance Payment Created Successfully');
        return true;
      } else if (response.statusCode == 400 || response.statusCode == 500) {
        final resp = jsonDecode(response.body);
        final message = resp['message'] ?? resp['error'] ?? 'Unknown error';
        print('❌ Backend Error: $message');
        return false;
      } else if (response.statusCode == 404) {
        print('❌ 404 Not Found – Check endpoint URL and HTTP method!');
        return false;
      } else {
        print('❌ Unexpected error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Exception occurred: $e');
      return false;
    }
  }
}

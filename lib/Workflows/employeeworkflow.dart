import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/employeemodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class EmployeeWorkflow {
  static const String endpoint = '/api/Employee';
  static Future<Map<String, dynamic>> createEmployeeWithResponse(
    EmployeeModel employee,
  ) async {
    try {
      final token = await TokenStorage.getToken();

      if (token == null || token.isEmpty) {
        print('❌ No token found');
        return {
          'success': false,
          'message': 'Authentication token is missing.',
        };
      }

      final url = Uri.parse('${ApiClient.baseUrl}$endpoint');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode(employee.toJson());
      print('📤 POST to $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(url, headers: headers, body: body);

      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Employee created successfully.',
          'data': jsonDecode(response.body),
        };
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Bad Request',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Unauthorized: Invalid or expired token.',
        };
      } else {
        return {
          'success': false,
          'message':
              'Failed to create employee. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print(' Exception in createEmployeeWithResponse: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}

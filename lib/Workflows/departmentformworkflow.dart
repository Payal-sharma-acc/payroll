import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/departmentformmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class DepartmentWorkflow {
  static Future<Departmentformmodel?> createDepartment(
    Departmentformmodel request,
  ) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/Department');

    try {
      final token = await TokenStorage.getToken();

      if (token == null) {
        print("❌ No token found. User might not be logged in.");
        
        return null;
      }
      final requestBody = jsonEncode(request.toJson());
      print(" Request Body: $requestBody");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          
          'Authorization': 'Bearer $token', 
        },
        body: jsonEncode(request.toJson()),
        
      );

      print("📦 Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Departmentformmodel.fromJson(jsonDecode(response.body));
        
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}

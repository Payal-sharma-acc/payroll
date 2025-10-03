import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/departmentdeletemodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class DepartmentDeleteWorkflow {
  static Future<DepartmentDeleteModel?> deleteDepartment(int id) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        print("❌ No token found. User might not be logged in.");
        return null;
      }

      final Uri url = ApiClient.buildUri('/api/Department/$id');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📦 Delete Response Status: ${response.statusCode}');
      print('📦 Delete Response Body: ${response.body}');

     if (response.statusCode == 200) {
  return DepartmentDeleteModel(message: response.body);
} else {
  print('❌ Delete failed: ${response.statusCode} ${response.body}');
  return null;
}
    } catch (e) {
      print('❌ Exception during delete: $e');
      return null;
    }
  }
}

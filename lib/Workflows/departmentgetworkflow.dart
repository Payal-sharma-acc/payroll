import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/departmentgetmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class DepartmentgetWorkflow {
  static Future<List<Departmentgetmodel>> getDepartments() async {
    final url = ApiClient.buildUri('/api/Department');

    try {
       final token = await TokenStorage.getToken();
        final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token", // 🔹 attach token
        },
      );
     

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Departmentgetmodel.fromJson(json)).toList();
      } else {
        print('❌ Failed to load departments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Exception: $e');
      return [];
    }
  }
}

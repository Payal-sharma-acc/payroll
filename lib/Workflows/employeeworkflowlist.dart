import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/employeelistmodel.dart';
import '../api_client.dart';
import '../utils/token_storage.dart';

class Employeeworkflowlist {
  static Future<List<Employeelistmodel>> getEmployees() async {
    final Uri url = ApiClient.buildUri("/api/Employee");

    try {
      final token = await TokenStorage.getToken();

      if (token == null) {
        print(" Token not found. User may not be logged in.");
        return [];
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          print(" API call successful, but employee list is empty.");
          return [];
        }

        final employees = data.map((e) => Employeelistmodel.fromJson(e)).toList();
        print(" Fetched ${employees.length} employees.");
        return employees;
      } else {
        print(" Failed to fetch employee list. Status: ${response.statusCode}");
        print("Response: ${response.body}");
        return [];
      }
    } catch (e) {
      print(" Exception while fetching employees: $e");
      return [];
    }
  }
}

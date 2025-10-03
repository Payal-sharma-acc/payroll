import 'dart:convert';
import 'package:payrollapp/Models/employeedetailsmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class EmployeedetailsWorkflow {
  static Future<Employeedetailsmodel?> getEmployeeById(int id) async {
  try {
    final token = await TokenStorage.getToken();
    print("Token: $token");

    final response = await ApiClient.get(
      "/api/Employee/$id",
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      print("JSON Body: $jsonBody");
      final data = jsonBody["data"] ?? jsonBody; 
      return Employeedetailsmodel.fromJson(data);
    } else {
      print("Error fetching employee");
      return null;
    }
  } catch (e) {
    print("Exception: $e");
    return null;
  }
}
}
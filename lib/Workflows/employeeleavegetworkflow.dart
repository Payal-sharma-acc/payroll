import 'dart:convert';
import 'package:payrollapp/Models/employeeleavegetmodel.dart';
import 'package:payrollapp/api_client.dart';

class EmployeeLeavegetWorkflow {
  Future<List<EmployeeLeavegetModel>> getEmployeeLeaves() async {
    final response = await ApiClient.get("/api/EmployeeLeave");

    print("🔹 Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData["data"];
      return data.map((e) => EmployeeLeavegetModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch employee leaves: ${response.body}");
    }
  }
}

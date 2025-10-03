import 'dart:convert';
import 'package:payrollapp/Models/employeeleavepostmodel.dart';
import 'package:payrollapp/api_client.dart';

class EmployeepostLeaveWorkflow {
  Future<void> applyLeave(EmployeepostLeaveModel leave) async {
    final response = await ApiClient.post(
      '/api/EmployeeLeave',
      body: json.encode(leave.toJson()), 
    );

    print("🔹 Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to apply leave: ${response.body}");
    }
  }
}

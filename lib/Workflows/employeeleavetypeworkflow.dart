import 'dart:convert';

import 'package:payrollapp/Models/employeeleavetypemodel.dart';
import 'package:payrollapp/api_client.dart';

class LeaveTypeWorkflow {
  static const String endpoint = "/api/LeaveType";

  static Future<List<LeaveTypeModel>> getAllLeaveTypes() async {
    try {
      final response = await ApiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        return decoded
            .map((e) => LeaveTypeModel.fromJson(e))
            .where((leave) => leave.isActive)
            .toList();
      } else {
        throw Exception("Failed to fetch leave types: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching leave types: $e");
    }
  }

  getEmployeeLeaves() {}
}

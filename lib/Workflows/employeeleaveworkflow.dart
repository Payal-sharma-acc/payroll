import 'dart:convert';
import 'package:payrollapp/Models/employeeleavemodel.dart';
import 'package:payrollapp/api_client.dart';

class Employeeleaveworkflow {
  Future<List<Employeeleavemodel>> getActiveLeaveTypes() async {
    final response = await ApiClient.get("/api/LeaveType/active");

    print("🔹 Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Employeeleavemodel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch leave types: ${response.body}");
    }
  }
}

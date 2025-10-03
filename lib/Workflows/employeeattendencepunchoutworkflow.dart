import 'dart:convert';
import 'package:payrollapp/Models/employeeattendencepunchoutmodel.dart';
import 'package:payrollapp/api_client.dart';

class Employeeattendencepunchoutworkflow {
  static Future<Employeeattendencepunchoutmodel?> updateAttendance(
      Employeeattendencepunchoutmodel model) async {
    try {
      final response = await ApiClient.put(
        "/api/Attendance/update",
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Employeeattendencepunchoutmodel.fromJson(data);
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception in updateAttendance: $e");
      return null;
    }
  }
}

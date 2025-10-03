import 'dart:convert';
import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:payrollapp/Models/employeeupcomingholidaysmodel.dart';
import 'package:payrollapp/api_client.dart';

class EmployeeHolidayWorkflow {
  final String endpoint = "/api/HolidayListMaster/get-all";

  Future<List<EmployeeHolidayModel>> getAllHolidays() async {
    final response = await ApiClient.get(endpoint);

    debugPrint("📦 Raw Holiday API Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      debugPrint("📝 Parsed Holiday JSON Data: $data");

      return data.map((json) => EmployeeHolidayModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch holidays: ${response.statusCode}");
    }
  }
}

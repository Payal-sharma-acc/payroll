import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/payschedulemodel.dart';
import 'package:payrollapp/api_client.dart';


class PayScheduleWorkflow {
  
  Future<bool> createPaySchedule(PayScheduleModel model) async {
    final Uri url = ApiClient.buildUri("/api/PaySchedule/create");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(" Pay schedule created successfully.");
        return true;
      } else {
        print(" Failed to create pay schedule. Status: ${response.statusCode}");
        print("Response: ${response.body}");
        return false;
      }
    } catch (e) {
      print(" Exception during API call: $e");
      return false;
    }
  }
}

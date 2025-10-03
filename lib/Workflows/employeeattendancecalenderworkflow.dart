import 'dart:convert';
import 'package:payrollapp/Models/employeeattendancecalendermodel.dart';
import 'package:payrollapp/api_client.dart';

class Employeeattendancecalenderworkflow {
  static Future<List<Employeeattendancecalendermodel>> getAllAttendance() async {
    try {
      final response = await ApiClient.get('/api/Attendance/all');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => Employeeattendancecalendermodel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load attendance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching attendance: $e');
      throw Exception('Error fetching attendance: $e');
    }
  }
}

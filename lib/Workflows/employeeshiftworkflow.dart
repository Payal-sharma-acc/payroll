import 'dart:convert';
import 'package:payrollapp/Models/employeeshiftmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class Employeeshift {
  static Future<List<Employeeshiftmodel>> getAllShifts() async {
    final token = await TokenStorage.getToken();
    final response = await ApiClient.get(
      '/api/Shift',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Employeeshiftmodel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load shifts: ${response.body}');
    }
  }
  static Future<Employeeshiftmodel> getShiftById(int id) async {
    final token = await TokenStorage.getToken();
    final response = await ApiClient.get(
      '/api/Shift/$id',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Employeeshiftmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load shift: ${response.body}');
    }
  }
}

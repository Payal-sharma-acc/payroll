import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/employeesalaryslipmodel.dart';
import 'package:payrollapp/api_client.dart';

class EmployeeSalarySlipWorkflow {
  final String endpoint = "/api/EmployeeSalarySlip/get";

  Future<List<EmployeeSalarySlipModel>> getSalarySlip({
    required int employeeId,
    required int year,
    required int month,
  }) async {
    final response = await ApiClient.get(
      "$endpoint?employeeId=$employeeId&year=$year&month=$month",
    );
      print("📤 Request Body: ${jsonEncode({
      "employeeId": employeeId,
      "year": year,
      "month": month,
    })}");
    print("📥 Response: ${response.statusCode}");
    print("📥 Body: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => EmployeeSalarySlipModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch salary slips");
    }
  }
}

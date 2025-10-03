import 'dart:convert';
import 'package:payrollapp/Models/employeeadvancedpaymnetapprovebymodel.dart';
import 'package:payrollapp/api_client.dart';

class EmployeeRoleMappingWorkflow {

  static Future<List<EmployeeRoleMappingModel>> fetchApprovers() async {
    final response = await ApiClient.get(
      "/api/EmployeeRoleMapping/approvers/all",
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => EmployeeRoleMappingModel.fromJson(e)).toList();
    } else {
      throw Exception(
        "Failed to load approvers (Status: ${response.statusCode}) - ${response.body}",
      );
    }
  }
  static Future<bool> saveApprovers(EmployeeRoleMappingModel model) async {
    final response = await ApiClient.post(
      "/api/EmployeeRoleMapping",
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
        "Failed to save approvers (Status: ${response.statusCode}) - ${response.body}",
      );
    }
  }
}

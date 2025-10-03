import 'dart:convert';
import 'package:payrollapp/Models/employeeleaveapprovedbymodel.dart';
import 'package:payrollapp/api_client.dart';
import '../utils/token_storage.dart';

class Employeeleaveapprovedbyworkflow {
  static Future<List<Employeeleaveapprovedbymodel>> getEmployeesByCompanyId() async {
    try {
      
final storedCompanyId = await TokenStorage.getCompanyId();
print("Company ID from storage: $storedCompanyId");
      final response = await ApiClient.get('api/user-auth/getEmployee/companyId/$storedCompanyId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body['status'] == 200 && body['data'] != null) {
          List<Employeeleaveapprovedbymodel> employees = (body['data'] as List)
              .map((e) => Employeeleaveapprovedbymodel.fromJson(e))
              .toList();
          return employees;
        } else {
          throw Exception(body['message'] ?? 'Failed to fetch employees');
        }
      } else {
        throw Exception('Failed to fetch employees. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employees: $e');
      throw Exception('Error fetching employees: $e');
    }
  }
}

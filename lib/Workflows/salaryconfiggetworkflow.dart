import 'dart:convert';
import 'package:payrollapp/Models/salaryconfiggetmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class SalaryConfiggetWorkflow {
  Future<List<Salaryconfiggetmodel>> getConfigByOrg(int orgId) async {
    try {
 
      final token = await TokenStorage.getToken(); 
      if (token == null) throw Exception("Auth token not found");
      final response = await ApiClient.get(
        "/api/OrgComponentConfig/by-org?orgId=$orgId",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("GET Status: ${response.statusCode}");
      print("GET Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];
        return data.map((e) => Salaryconfiggetmodel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch salary config: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception during salary config fetch: $e");
      rethrow;
    }
  }
}

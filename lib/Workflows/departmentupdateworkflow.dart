import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/departmentupdatemodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class Departmentupdateworkflow {
  static Future<Departmentupdatemodel?> updateDepartment({
    required int id,
    required String name,
    required String description,
    required String adminUserId,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final Uri url = ApiClient.buildUri('/api/Department/$id');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "name": name,
          "description": description,
          "adminUserId": adminUserId,
        }),
      );

      print('📦 Update Response Status: ${response.statusCode}');
      print('📦 Update Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return Departmentupdatemodel(
          message: response.body,
          id: id,
          name: name,
          description: description,
        );
      }
      return null;
    } catch (e) {
      print('❌ Exception during update: $e');
      return null;
    }
  }
  static Future<Departmentupdatemodel?> fetchDepartmentById(int id) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final Uri url = ApiClient.buildUri('/api/Department/$id');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📦 Fetch Response Status: ${response.statusCode}');
      print('📦 Fetch Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Departmentupdatemodel.fromJson(json);
      }
      return null;
    } catch (e) {
      print('❌ Exception during fetch: $e');
      return null;
    }
  }
}

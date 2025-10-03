import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/permissiongetmodel.dart';
import 'package:payrollapp/api_client.dart';

class Permissiongetworkflow {
  Future<List<Permissiongetmodel>> getPermissionsByAdminId(int adminUserId, String token) async {
    final url = ApiClient.buildUri('/api/Permission/admin/$adminUserId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Permissiongetmodel.fromJson(json)).toList();
    } else {
      print(" Failed to fetch admin permissions: ${response.statusCode}");
      throw Exception('Failed to load permissions');
    }
  }
}

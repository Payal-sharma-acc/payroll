import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/designationupdatemodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart'; 

class designationupdateworkflow {
  final String _baseUrl = ApiClient.baseUrl;

  Future<Designationupdatemodel?> getDesignationById(int id) async {
    final token = await TokenStorage.getToken(); 

    final response = await http.get(
      Uri.parse('$_baseUrl/api/Designation/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Designationupdatemodel.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to load designation: ${response.body}');
      return null;
    }
  }

  Future<bool> updateDesignation(Designationupdatemodel model) async {
    final token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse('$_baseUrl/api/Designation/${model.id}'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(model.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteDesignation(int id) async {
    final token = await TokenStorage.getToken();

    final response = await http.delete(
      Uri.parse('$_baseUrl/api/Designation/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/designationmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart'; 

class DesignationWorkflow {
  static final String _endpoint = '/api/Designation';

  static Future<List<designationmodel>> getAllDesignations() async {
    final uri = ApiClient.buildUri(_endpoint);
    final token = await TokenStorage.getToken();

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('GET $_endpoint => ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => designationmodel.fromJson(e)).toList();
      } else {
        print('Failed to load designations: ${response.statusCode}');
        throw Exception('Failed to load designations');
      }
    } catch (e) {
      print('Error fetching designations: $e');
      rethrow;
    }
  }

  Future<bool> addDesignation(designationmodel designation) async {
    final uri = ApiClient.buildUri(_endpoint);
    final token = await TokenStorage.getToken();

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(designation.toJson()),
      );

      print('POST $_endpoint => ${response.statusCode}');
      print('Request Body: ${json.encode(designation.toJson())}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding designation: $e');
      return false;
    }
  }
}

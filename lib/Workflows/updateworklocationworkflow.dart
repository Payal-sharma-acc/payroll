import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/updateworklocationmodel.dart';
import 'package:payrollapp/api_client.dart';
import '../utils/token_storage.dart'; 

class UpdateWorkLocationWorkflow {
  Future<bool> updateWorkLocation(String id, updateworklocationmodel model) async {
    final url = ApiClient.buildUri('/api/WorkLocation/$id');
    final token = await TokenStorage.getToken();

    if (token == null) {
      print('Token not found');
      return false;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Failed to update work location: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception updating work location: $e');
      return false;
    }
  }
}

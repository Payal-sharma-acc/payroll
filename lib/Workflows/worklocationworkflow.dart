import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/worklocationmodel.dart';
import '../api_client.dart';
import '../utils/token_storage.dart'; 

class WorkLocationWorkflow {
  Future<bool> saveWorkLocation(Worklocationmodel model) async {
    final url = ApiClient.buildUri('/api/WorkLocation');
    final token = await TokenStorage.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(model.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Save error: $e');
      return false;
    }
  }

  Future<bool> updateWorkLocation(Worklocationmodel model) async {
    final url = ApiClient.buildUri('/api/WorkLocation');
    final token = await TokenStorage.getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(model.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Update error: $e');
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/worklocationgetmodel.dart';
import '../api_client.dart';
import '../utils/token_storage.dart'; 

class Worklocationgetworkflow {
  Future<bool> saveWorkLocation(Worklocationgetmodel model) async {
    final url = ApiClient.buildUri('/api/WorkLocation');
    final token = await TokenStorage.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': model.name,
          'addressLine1': model.addressLine1,
          'addressLine2': model.addressLine2,
          'state': model.state,
          'city': model.city,
          'pinCode': model.pinCode,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Save error: $e');
      return false;
    }
  }

  Future<bool> updateWorkLocation(Worklocationgetmodel model) async {
    final url = ApiClient.buildUri('/api/WorkLocation');
    final token = await TokenStorage.getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': model.name,
          'addressLine1': model.addressLine1,
          'addressLine2': model.addressLine2,
          'state': model.state,
          'city': model.city,
          'pinCode': model.pinCode,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Update error: $e');
      return false;
    }
  }

  static Future<List<Worklocationgetmodel>> getWorkLocations() async {
    final url = ApiClient.buildUri('/api/WorkLocation');
    final token = await TokenStorage.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Worklocationgetmodel.fromJson(e)).toList();
      } else {
        print('Failed to fetch work locations: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching work locations: $e');
      return [];
    }
  }
}

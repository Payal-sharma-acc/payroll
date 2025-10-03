import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/utils/token_storage.dart';
import '../Models/payseduleaddemployeemodel.dart';
import '../api_client.dart';

class Payseduleaddemployeeworkflow {
  static Future<List<Payseduleaddemployeemodel>> getAllPaySchedules() async {
    try {
      final url = ApiClient.buildUri('/api/PaySchedule/all');
      final token = await TokenStorage.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body
            .map((e) => Payseduleaddemployeemodel.fromJson(e))
            .toList();
      } else {
        print('Failed to load pay schedules. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching pay schedules: $e');
      return [];
    }
  }
}

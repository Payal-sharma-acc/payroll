import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/employeeoutduitymodel.dart';
import 'package:payrollapp/utils/token_storage.dart';

class Employeeoutduityworkflow {
  static const String baseUrl = "https://digipaystaggingapi.digicodesoftware.com";

  Future<List<Employeeoutduitymodel>> getAllOnDuty() async {
    final token = await TokenStorage.getToken();
    print(" Token: $token");
    final url = Uri.parse("$baseUrl/api/OnDuty");
    print(" Full GET URL: $url");

    http.Response response;
    try {
      response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print("Status code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Body: ${response.body}");
    } catch (e) {
      print("❌ API call failed: $e");
      rethrow;
    }
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null && jsonData['data'] is List) {
          final List data = jsonData['data'];
          return data.map((e) => Employeeoutduitymodel.fromJson(e)).toList();
        } else {
          print("⚠️ Warning: 'data' field missing or not a list");
          return [];
        }
      } catch (e) {
        print("❌ JSON parsing failed: $e");
        return [];
      }
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Token missing or invalid");
    } else if (response.statusCode == 404) {
      throw Exception("Not Found: Check endpoint path or spelling");
    } else {
      throw Exception("Failed to load OnDuty data: ${response.statusCode}");
    }
  }
}

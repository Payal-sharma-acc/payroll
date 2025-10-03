import 'dart:convert';
import 'package:payrollapp/Models/employeeloginmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_client.dart';

class EmployeeLoginWorkflow {
  static const String loginEndpoint = "/api/user-auth/employee-authenaticqtio";

  Future<EmployeeLoginModel?> login(EmployeeLoginModel request) async {
    try {
      final response = await ApiClient.post(
        loginEndpoint,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJsonRequest()),
      );
      print(" Request Body: ${jsonEncode(request.toJsonRequest())}");
      print(" Status Code: ${response.statusCode}");
      print(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(" Parsed Response: $data");
        final loginResponse = EmployeeLoginModel.fromJson(data);
        if (loginResponse.token != null) {
          await saveToken(loginResponse.token!);
          print(" Token saved: ${loginResponse.token}");
        }
        if (loginResponse.fullName != null) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("fullName", loginResponse.fullName!);
    print(" FullName saved: ${loginResponse.fullName}");
  }

        return loginResponse;
      } else {
        throw Exception("Login failed: ${response.body}");
      }
    } catch (e) {
      print(" Error in login: $e");
      rethrow;
    }
  }
  

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/logoutmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class LogoutWorkflow {
  Future<bool> logout(Logoutmodel model) async {
    final url = ApiClient.buildUri('/api/user-auth/logout');

    try {
    
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        print(" No refresh token found.");
        return false;
      }

      final body = jsonEncode({"refreshToken": refreshToken});
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("Request Body: $body");
      print("Logout Response: ${response.statusCode} - ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print(" Exception during logout: $e");
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/forgotpasswordmodel.dart';
import 'package:payrollapp/api_client.dart';

class ForgotPasswordWorkflow {
  Future<bool> sendForgotPasswordRequest(ForgotPasswordModel model) async {
    final uri = ApiClient.buildUri('/api/user-auth/forgot-password');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
          " Forgot Password failed: ${response.statusCode} - ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Error during forgot password: $e");
      return false;
    }
  }
}

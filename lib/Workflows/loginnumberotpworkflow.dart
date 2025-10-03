import 'dart:convert';
import 'package:payrollapp/Models/loginnumberotpmodel.dart';
import 'package:payrollapp/api_client.dart';

class Loginnumberotpworkflow {
  Future<Map<String, dynamic>?> loginWithOtp(Loginnumberotpmodel model) async {
    try {
      final response = await ApiClient.post(
        '/api/user-auth/login-with-otp',
        body: jsonEncode(model.toJson()),
        requiresAuth: false,
      );

      print(" Login OTP Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ApiClient.token = data['token'];

        return data; 
      } else {
        print(" Login failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(" Exception during login with OTP: $e");
      return null;
    }
  }
}

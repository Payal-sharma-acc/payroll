import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/loginwithotpmodel.dart';
import 'package:payrollapp/api_client.dart';

class loginwithotpworkflow {
  Future<Loginwithotpmodel?> sendOtp(Loginwithotpmodel model) async {
    final url = ApiClient.buildUri('/api/user-auth/send-login-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Loginwithotpmodel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      throw Exception("Failed to send OTP: $e");
    }
  }
}

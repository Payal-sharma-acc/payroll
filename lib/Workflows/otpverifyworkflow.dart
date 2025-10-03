import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/otpverifymodel.dart';
import 'package:payrollapp/api_client.dart'; 

class Otpverifyworkflow {
  Future<bool> verifyOtp(Otpverifymodel model) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/user-auth/verify-otp');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJson()),
      );

      print(" Request Body: ${jsonEncode(model.toJson())}");
      print(" Response Code: ${response.statusCode}");
      print(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {

        final data = jsonDecode(response.body);
        print(" Error Message: ${data['message']}");
        return false;
      }
    } catch (e) {
      print(" Exception: $e");
      return false;
    }
  }
}

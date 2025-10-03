import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/signupmodel.dart';
import 'package:payrollapp/api_client.dart';

class Signupworkflow {
  Future<String> signup(SignupModel model) async {
    final url = ApiClient.buildUri('/api/user-auth/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        print("Signup successful: ${response.body}");
        return 'success';
      } else if (response.statusCode == 409 || response.body.contains('already exists')) {
        print("Signup failed: User already exists");
        return 'User already exists';
      } else {
        final body = jsonDecode(response.body);
        print("Signup failed: ${response.statusCode} - ${body['message'] ?? response.body}");
        return body['message'] ?? 'Signup failed';
      }
    } catch (e) {
      print("Error during signup: $e");
      return 'Something went wrong. Please try again.';
    }
  }
}

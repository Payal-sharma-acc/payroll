import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/forgototpmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart'; 

class ForgotOtpWorkflow {
  static Future<ForgotOtpModel> verifyResetOtp({
    required String emailOrPhone,
    required String otp,
  }) async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}/api/user-auth/verify-reset-otp');

      final body = jsonEncode({
        'emailOrPhone': emailOrPhone,
        'otp': otp,
      });

      print(' Sending OTP verification to $url');
      print(' Body: $body');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(' Status Code: ${response.statusCode}');
      print(' Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final model = ForgotOtpModel.fromJson(data);
        if (model.resetToken.isNotEmpty) {
          await TokenStorage.saveResetToken(model.resetToken);
          print(" Reset token stored successfully: ${model.resetToken}");
        }

        return model;
      } else {
        return ForgotOtpModel(
          message: data['message'] ?? 'OTP verification failed',
          success: false,
          resetToken: '',
        );
      }
    } catch (e) {
      print(' Exception during OTP verification: $e');
      return ForgotOtpModel(
        message: 'Something went wrong',
        success: false,
        resetToken: '',
      );
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/resetpasswordmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class ResetPasswordWorkflow {
  Future<bool> resetPassword(String newPassword) async {
    final uri = ApiClient.buildUri('/api/user-auth/reset-password-with-token');

    try {
      final resetToken = await TokenStorage.getResetToken();

      if (resetToken == null || resetToken.isEmpty) {
        print(" No reset token found. Cannot reset password.");
        return false;
      }
      final model = ResetPasswordModel(
        resetToken: resetToken,
        newPassword: newPassword,
      );

      final payload = model.toJson();

      print(' Sending reset password request to $uri');
      print(' Request Body: ${jsonEncode(payload)}');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(' Password reset successful: ${responseData['message']}');
        await TokenStorage.clearResetToken(); 
        return true;
      } else {
        print(' Reset failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print(' Exception occurred during password reset: $e');
      return false;
    }
  }
}

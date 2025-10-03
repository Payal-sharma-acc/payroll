import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/loginmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/error_logger.dart';
import 'package:payrollapp/utils/token_storage.dart';

class LoginWorkflow {
  Future<Map<String, dynamic>?> login(Loginmodel model) async {
    final url = ApiClient.buildUri('/api/user-auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        print('Login response: $jsonBody');
        if (jsonBody['token'] != null && jsonBody['token'] != "") {
          final token = jsonBody['token'];
          await TokenStorage.saveToken(token);
         final payload = _decodeJwt(token);
  if (payload != null) {
    final adminIdStr = payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
    if (adminIdStr != null) {
      final adminId = int.tryParse(adminIdStr.toString());
      if (adminId != null) await TokenStorage.saveAdminUserId(adminId);
    }

    if (payload != null) {
  final companyIdStr = payload['CompanyId']; 
  final companyId = int.tryParse(companyIdStr.toString());
  if (companyId != null) {
    await TokenStorage.saveCompanyId(companyId);
    print('CompanyId saved: $companyId');
  }
}
    final name = payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'];
    if (name != null) await TokenStorage.saveFullName(name.toString());

            // Latitude
            final latStr = payload['Latitide'];
            if (latStr != null) {
              final lat = double.tryParse(latStr.toString());
              if (lat != null) await TokenStorage.saveLatitude(lat);
            }

            // Longitude
            final longStr = payload['Longitude'];
            if (longStr != null) {
              final long = double.tryParse(longStr.toString());
              if (long != null) await TokenStorage.saveLongitude(long);
            }

        
          }
        }

        return jsonBody;
      } else {
        final errorMsg = "Login failed: ${response.statusCode} - ${response.body}";
        print(errorMsg);
        await ErrorLogger.log(errorMsg);
        return null;
      }
    } catch (e) {
      final errorMsg = "Exception during login: $e";
      print(errorMsg);
      await ErrorLogger.log(errorMsg);
      return null;
    }
  }
  Map<String, dynamic>? _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final jsonPayload = jsonDecode(payload);

      print('✅ Decoded JWT payload: $jsonPayload');
      return jsonPayload;
    } catch (e) {
      print("❌ JWT decode error: $e");
      return null;
    }
  }
}

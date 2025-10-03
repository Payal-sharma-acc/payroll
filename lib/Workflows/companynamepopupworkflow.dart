import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/utils/token_storage.dart';
import '../Models/companynamepopupmodel.dart';
import '../api_client.dart';

class Companynamepopupworkflow {
  Future<Companynamepopupmodel?> createCompany(
      Companynamepopupmodel model) async {
    final url = ApiClient.buildUri('/api/Company/create');
    final adminUserId = await TokenStorage.getAdminUserId();
    final body = jsonEncode({
      "companyName": model.companyName,
      "companyCode": model.companyCode,
      if (adminUserId != null) "adminUserId": adminUserId,
    });
    final token = await TokenStorage.getToken();
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("===== API CALL =====");
      print("POST $url");
      print("Headers: $headers");
      print("Request body: $body");
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      print("===================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['company'] != null) {
          final company =
              Companynamepopupmodel.fromJson(jsonResponse['company']);
          if (jsonResponse['token'] != null && jsonResponse['token'] != "") {
            await TokenStorage.saveToken(jsonResponse['token']);
          }

          return company;
        } else {
          print("⚠️ 'company' field missing in response JSON");
          return null;
        }
      } else {
        print("❌ API error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception during API call: $e");
      return null;
    }
  }
}

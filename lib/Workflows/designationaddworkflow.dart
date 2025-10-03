import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/designationpostmodel.dart';
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/Models/designationmodel.dart';
import 'package:payrollapp/utils/token_storage.dart';

class designationaddworkflow {
  final String _endpoint = "/api/Designation";

  Future<designationPostModel?> createDesignation(designationPostModel model) async {
    final url = Uri.parse("${ApiClient.baseUrl}$_endpoint");

    try {
      final token = await TokenStorage.getToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token', // 🔹 pass token
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return designationPostModel.fromJson(data);
      } else {
        print("Error ${response.statusCode}: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null;
    }
  }
}

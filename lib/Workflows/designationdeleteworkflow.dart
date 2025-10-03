import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/api_client.dart';
import 'package:payrollapp/utils/token_storage.dart'; 

class DesignationDeleteWorkflow {
  final String _baseUrl = ApiClient.baseUrl;

  Future<bool> deleteDesignation(int id) async {
    final url = Uri.parse('$_baseUrl/api/Designation/$id');

    try {
      final token = await TokenStorage.getToken();

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('Delete Response: $body');
        return true;
      } else {
        print('Failed to delete. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error deleting designation: $e');
      return false;
    }
  }
}

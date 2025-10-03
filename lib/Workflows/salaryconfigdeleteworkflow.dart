import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/salaryconfigdeletemodel.dart';
import 'package:payrollapp/api_client.dart';

class SalaryConfigDeleteWorkflow {
  Future<SalaryConfigDeleteModel> deleteComponentById(int configId) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/OrgComponentConfig/$configId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final responseBody = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return SalaryConfigDeleteModel.fromJson(responseBody);
      } else {
        final errorMessage = responseBody['message'] ?? 'Unknown error occurred';
        
        if (response.statusCode == 404) {
          throw Exception('Configuration not found: $errorMessage');
        } else {
          throw Exception('Failed to delete configuration (${response.statusCode}): $errorMessage');
        }
      }
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
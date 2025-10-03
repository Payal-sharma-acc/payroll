import 'package:http/http.dart' as http;
import 'package:payrollapp/api_client.dart';

class DeleteWorkLocationWorkflow {
  final String _endpoint = '/api/WorkLocation';
  Future<bool> deleteWorkLocation(int id) async {
    try {
      final uri = ApiClient.buildUri('$_endpoint/$id');
      final response = await http.delete(uri);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }
}

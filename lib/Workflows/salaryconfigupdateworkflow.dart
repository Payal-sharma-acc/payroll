import 'dart:convert';
import 'package:payrollapp/Models/salaryconfigmodel.dart';
import 'package:payrollapp/Models/salaryconfigupdatemodel.dart';
import 'package:payrollapp/api_client.dart';

class Salaryconfigupdateworkflow {
  Future<Salaryconfigupdatemodel?> getConfigById(int id) async {
    try {
      final response = await ApiClient.get('/api/OrgComponentConfig/$id');

      print('GET Status: ${response.statusCode}');
      print('GET Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Salaryconfigupdatemodel.fromJson(data);
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception while fetching config: $e');
      return null;
    }
  }

  Future<bool> updateConfig(Salaryconfigmodel model) async {
    try {
      if (model.componentConfigId == null) {
        print('Error: componentConfigId is required.');
        return false;
      }
      final jsonBody = jsonEncode({
        'id': model.componentConfigId,
        'orgId': model.orgId,
        'componentName': model.componentName,
        'isEnabled': model.isEnabled,
        'calculationType': model.calculationType,
        'percentageValue': model.percentageValue,
        'fixedAmount': model.fixedAmount,
      });

      print('Request Body: $jsonBody');
      final response = await ApiClient.put(
        '/api/OrgComponentConfig/${model.componentConfigId}', 
        body: jsonBody,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('PUT Status: ${response.statusCode}');
      print('PUT Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Update successful');
        return true;
      } else {
        print('Failed to update config: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception during update: $e');
      return false;
    }
  }
}
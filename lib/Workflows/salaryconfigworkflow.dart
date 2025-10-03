import 'dart:convert';
import 'package:payrollapp/Models/salaryconfigmodel.dart';
import 'package:payrollapp/api_client.dart';

class Salaryconfigworkflow {
  Future<void> saveComponentConfig(List<Salaryconfigmodel> components) async {
    try {
      print("Sending request with components:");
      components.forEach((comp) => print(comp.toJson()));
      
      final jsonPayload = jsonEncode(components.map((e) => e.toJson()).toList());
      print("JSON Payload: $jsonPayload");
      
      final response = await ApiClient.post(
        "/api/OrgComponentConfig/save",
        body: jsonPayload,
        headers: {'Content-Type': 'application/json'},
      );
      print("\n=== API Response ===");
      print("Status Code: ${response.statusCode}");
      print("Raw Response: ${response.body}");
      
      final decoded = jsonDecode(response.body);
      print("Decoded JSON: $decoded");
      
      if (decoded['data'] != null && decoded['data'].isNotEmpty) {
        print("Type of orgId in response: ${decoded['data'][0]['orgId']?.runtimeType}");
        print("First item details: ${decoded['data'][0]}");
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = decoded['data'];
        print("\nParsed data before mapping:");
        data.forEach((item) => print(item));
        
        return; 
      } else {
        throw Exception(decoded['message'] ?? 'Failed to save config');
      }
    } catch (e) {
      print("\n!!! Error in saveComponentConfig !!!");
      print("Error details: $e");
      print("Stack trace: ${e is Error ? e.stackTrace : ''}");
      rethrow;
    }
  }

  Future<List<Salaryconfigmodel>> getComponentConfigByOrgId(String orgId) async {
    try {
      print("\nFetching configs for orgId: $orgId");
      final response = await ApiClient.get(
        "/api/OrgComponentConfig/by-org?orgId=$orgId",
      );

      print("\n=== GET Response ===");
      print("Status Code: ${response.statusCode}");
      print("Raw Response: ${response.body}");
      
      final decoded = jsonDecode(response.body);
      print("Decoded JSON: $decoded");
      
      if (decoded['data'] != null && decoded['data'].isNotEmpty) {
        print("Type of orgId in response: ${decoded['data'][0]['orgId']?.runtimeType}");
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = decoded['data'];
        print("\nData received (${data.length} items):");
        data.take(3).forEach((item) => print(item)); 
        
        return data.map((e) => Salaryconfigmodel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch component configs: ${decoded['message'] ?? response.body}");
      }
    } catch (e) {
      print("\n!!! Error in getComponentConfigByOrgId !!!");
      print("Error details: $e");
      rethrow;
    }
  }

  Future<Salaryconfigmodel> updateComponentConfig(Salaryconfigmodel component) async {
    try {
      print("\nUpdating component: ${component.toJson()}");
      final response = await ApiClient.put(
        "/api/OrgComponentConfig/update",
        body: component.toJson(),
      );

      print("\n=== PUT Response ===");
      print("Status Code: ${response.statusCode}");
      print("Raw Response: ${response.body}");
      
      final decoded = jsonDecode(response.body);
      print("Decoded JSON: $decoded");
      
      if (decoded['data'] != null) {
        print("Updated component details: ${decoded['data']}");
        print("Type of orgId in response: ${decoded['data']['orgId']?.runtimeType}");
      }

      if (response.statusCode == 200) {
        return Salaryconfigmodel.fromJson(decoded['data']);
      } else {
        throw Exception("Failed to update component config: ${decoded['message'] ?? response.body}");
      }
    } catch (e) {
      print("\n!!! Error in updateComponentConfig !!!");
      print("Error details: $e");
      rethrow;
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrollapp/Models/permissionmodel.dart';
import 'package:payrollapp/api_client.dart';

class PermissionWorkflow {
  Future<bool> createPermission(Permissionmodel model) async {
    final Uri url = ApiClient.buildUri("/api/Permission/setapi");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Permission for ${model.moduleName} created successfully.");
        return true;
      } else {
        print("Failed to create permission for ${model.moduleName}. Status: ${response.statusCode}");
        print("Response: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception during API call for ${model.moduleName}: $e");
      return false;
    }
  }
  
  Future<void> createAllPermissions(List<Permissionmodel> models) async {
    for (var model in models) {
      await createPermission(model);
    }
  }
}

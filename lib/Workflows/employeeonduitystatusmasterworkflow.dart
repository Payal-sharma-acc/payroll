import 'dart:convert';
import 'package:payrollapp/Models/employeeonduitystatusmastermodel.dart';

import 'package:payrollapp/api_client.dart';

class StatusMasterWorkflow {
  static const String endpoint = "/api/StatusMaster";
  
 static Future<List<StatusMasterModel>> getAllStatuses() async {
  try {
    final response = await ApiClient.get(endpoint);
    print("🔹 Raw Response: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print("✅ Decoded Response: $decoded");

      if (decoded['data'] != null) {
        final list = (decoded['data'] as List)
            .map((e) => StatusMasterModel.fromJson(e))
            .toList();
        for (var status in list) {
          print("➡️ StatusId: ${status.statusId}, StatusName: ${status.statusName}, Code: ${status.statusCode}");
        }

        return list;
      }
    } else {
      throw Exception("❌ Failed to fetch statuses: ${response.body}");
    }
  } catch (e) {
    throw Exception("⚠️ Error in getAllStatuses: $e");
  }
  return [];
}
}
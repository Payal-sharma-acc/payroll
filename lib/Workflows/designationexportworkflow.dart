import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:payrollapp/api_client.dart';

class DesignationExportWorkflow {
  static Future<void> exportDesignation() async {
    const String endpoint = '/api/Designation/export';

    try {
      final response = await ApiClient.get(endpoint);

      if (response.statusCode == 200) {
        final directory = await getDownloadsDirectory() ?? await getTemporaryDirectory();
        final filePath = '${directory.path}/Designations_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        final result = await OpenFilex.open(filePath);
        if (result.type != ResultType.done) {
          throw Exception("Failed to open file: ${result.message}");
        }
      } else {
        throw Exception("Export failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Export error: ${e.toString()}");
    }
  }
}
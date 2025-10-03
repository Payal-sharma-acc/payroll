import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:payrollapp/Models/designationimportmodel.dart';
import 'package:payrollapp/api_client.dart';

class DesignationImportWorkflow {
  Future<List<DesignationImportModel>> importDesignation({
    required File file,
  }) async {
    try {
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      List<DesignationImportModel> designations = [];

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows.skip(1)) {
          final name = row[0]?.value?.toString().trim() ?? '';
          final level = row[1]?.value?.toString().trim() ?? '';

          if (name.isNotEmpty && level.isNotEmpty) {
            designations.add(DesignationImportModel(title: name, level: level));
          }
        }
      }
      final response = await ApiClient.post(
        '/api/Designation/import',
        body: jsonEncode(designations.map((e) => e.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        return designations;
      } else {
        throw Exception('Failed to import designations: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error importing designations: $e');
    }
  }
}

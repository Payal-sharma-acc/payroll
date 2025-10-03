import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ErrorLogger {
  static Future<void> log(String message, {StackTrace? stackTrace}) async {
    try {
      if (!Platform.isAndroid) return;

      final dir = Directory('/storage/emulated/0/Download');
      if (!(await dir.exists())) {
        await dir.create(recursive: true);
      }

      final file = File('${dir.path}/error_log.txt');
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final fullMessage = StringBuffer()
        ..writeln('[$timestamp] $message')
        ..writeln(stackTrace != null ? '📍 StackTrace:\n$stackTrace' : '');
      await file.writeAsString(fullMessage.toString(), mode: FileMode.append);
      if (kDebugMode) {
        print("📝 Error logged to: ${file.path}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Failed to write log: $e");
      }
    }
  }
}

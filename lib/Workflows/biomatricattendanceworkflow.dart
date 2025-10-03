import 'dart:convert';
import 'package:payrollapp/Models/biometricattendancemodel.dart';
import 'package:payrollapp/api_client.dart';

class AttendanceWorkflow {
  final String endpoint = "/api/Attendance";

  Future<Biomatricattendancemodel?> createAttendance(
    Biomatricattendancemodel model,
  ) async {
    final body = jsonEncode(model.toJson());

    print("POST $endpoint/create");
    print("Request Body: $body");
    print("Latitude: ${model.latitude}");
    print("Longitude: ${model.longitude}");

    final response = await ApiClient.post(
      "$endpoint/create",
      body: body,
      requiresAuth: true,
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Biomatricattendancemodel.fromJson(data);
    } else {
      throw Exception("Failed to create attendance: ${response.body}");
    }
  }

  Future<Biomatricattendancemodel?> getAttendanceById(int id) async {
    print("GET $endpoint/$id");

    final response = await ApiClient.get("$endpoint/$id");

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Fetched Latitude: ${data['latitude']}");
      print("Fetched Longitude: ${data['longitude']}");
      return Biomatricattendancemodel.fromJson(data);
    } else {
      throw Exception("Failed to fetch attendance: ${response.body}");
    }
  }

  Future<List<Biomatricattendancemodel>> getAllAttendances() async {
    print("GET $endpoint");

    final response = await ApiClient.get(endpoint);

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      for (var e in data) {
        print(
          "Record Latitude: ${e['latitude']}, Longitude: ${e['longitude']}",
        );
      }
      return data.map((e) => Biomatricattendancemodel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch attendances: ${response.body}");
    }
  }

  Future<Biomatricattendancemodel?> updateAttendance(
    int id,
    Biomatricattendancemodel model,
  ) async {
    final body = jsonEncode({...model.toJson(), "attendanceId": id});

    print("PUT $endpoint/update");
    print("Request Body: $body");
    print("Latitude: ${model.latitude}");
    print("Longitude: ${model.longitude}");

    final response = await ApiClient.put(
      "$endpoint/update",
      body: body,
      requiresAuth: true,
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Biomatricattendancemodel.fromJson(data);
    } else {
      throw Exception("Failed to update attendance: ${response.body}");
    }
  }

  Future<bool> deleteAttendance(int id) async {
    print("DELETE $endpoint/$id");

    final response = await ApiClient.delete("$endpoint/$id");

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception("Failed to delete attendance: ${response.body}");
    }
  }
}

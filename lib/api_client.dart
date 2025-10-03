import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:payrollapp/utils/token_storage.dart';

class ApiClient {
  //  static const String baseUrl = "https://digipaydevops.digicodesoftware.com";
  static const String baseUrl =
      "https://digipaystaggingapi.digicodesoftware.com";
  static IOClient createIOClient() {
    final HttpClient httpClient =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }

  static Uri buildUri(String path) {
    if (path.startsWith("http")) return Uri.parse(path);
    final sanitizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$sanitizedPath');
  }

  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final uri = buildUri(endpoint);
    final token = requiresAuth ? await TokenStorage.getToken() : null;

    final defaultHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      ...?headers,
    };

    return createIOClient().get(uri, headers: defaultHeaders);
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final uri = buildUri(endpoint);
    final token = requiresAuth ? await TokenStorage.getToken() : null;

    final defaultHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      ...?headers,
    };

    return createIOClient().post(uri, headers: defaultHeaders, body: body);
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final uri = buildUri(endpoint);
    final token = requiresAuth ? await TokenStorage.getToken() : null;

    final defaultHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      ...?headers,
    };

    return createIOClient().put(uri, headers: defaultHeaders, body: body);
  }

  static Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final uri = buildUri(endpoint);
    final token = requiresAuth ? await TokenStorage.getToken() : null;

    final defaultHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      ...?headers,
    };

    return createIOClient().delete(uri, headers: defaultHeaders);
  }

  static String? token;
}

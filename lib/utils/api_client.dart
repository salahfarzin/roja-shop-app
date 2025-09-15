// lib/services/http_client.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rojashop/utils/http_error.dart';

class ApiClient {
  final String baseUrl =
      dotenv.env['API_URL'] ?? 'http://localhost:3000/api/v1';
  final Map<String, String> defaultHeaders;

  ApiClient({this.defaultHeaders = const {"Content-Type": "application/json"}});

  /// Sends an HTTP request and returns the decoded JSON response.
  /// The return type can be Map<String, dynamic>, List<dynamic>, or null.
  Future<dynamic> request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final mergedHeaders = {...defaultHeaders, ...?headers};

    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            uri,
            headers: mergedHeaders,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: mergedHeaders,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: mergedHeaders);
          break;
        default: // GET
          response = await http.get(uri, headers: mergedHeaders);
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        }
        return null;
      } else {
        throw HttpError(
          'HTTP ${response.statusCode}: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      // Prefer e.message if available, else fallback to e.toString()
      final message = (e is HttpError)
          ? e.message
          : (e is Exception && e.toString().isNotEmpty
                ? e.toString()
                : 'Unknown error');
      throw HttpError(message, 500);
    }
  }
}

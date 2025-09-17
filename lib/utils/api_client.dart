// lib/services/http_client.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rojashop/utils/http_error.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

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
        String errorMsg = response.body;
        // Try to extract 'message' from JSON error response
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded.containsKey('message')) {
            errorMsg = decoded['message'].toString();
          }
        } catch (_) {
          // Not JSON, keep raw body
        }
        throw HttpError(errorMsg, response.statusCode);
      }
    } catch (e) {
      final message = (e is HttpError)
          ? e.message
          : (e is Exception && e.toString().isNotEmpty
                ? e.toString()
                : 'Unknown error');
      throw HttpError(message, 500);
    }
  }

  /// Sends a multipart/form-data POST request with fields and a file, with progress callback.
  Future<dynamic> multipartRequest(
    String path, {
    required Map<String, String> fields,
    String method = 'POST',
    String? fileField,
    String? filePath,
    Map<String, String>? headers,
    void Function(double progress)? onProgress,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = http.MultipartRequest(method, uri);
    request.fields.addAll(fields);
    if (fileField != null && filePath != null && filePath.isNotEmpty) {
      // Detect MIME type
      final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
      final parts = mimeType.split('/');
      final file = await http.MultipartFile.fromPath(
        fileField,
        filePath,
        contentType: MediaType(parts[0], parts[1]),
      );
      if (onProgress != null) {
        // Wrap file stream to report progress
        final total = file.length;
        int sent = 0;
        final stream = file.finalize().transform(
          StreamTransformer<List<int>, List<int>>.fromHandlers(
            handleData: (data, sink) {
              sent += data.length;
              onProgress(sent / total);
              sink.add(data);
            },
          ),
        );
        request.files.add(
          http.MultipartFile(
            file.field,
            stream,
            total,
            filename: file.filename,
            contentType: file.contentType,
          ),
        );
      } else {
        request.files.add(file);
      }
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    // Remove content-type header for multipart
    request.headers.removeWhere((k, v) => k.toLowerCase() == 'content-type');
    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        }
        return null;
      } else {
        String errorMsg = response.body;
        // Try to extract 'message' from JSON error response
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded.containsKey('message')) {
            errorMsg = decoded['message'].toString();
          }
        } catch (_) {
          // Not JSON, keep raw body
        }
        throw HttpError(errorMsg, response.statusCode);
      }
    } catch (e) {
      final message = (e is HttpError)
          ? e.message
          : (e is Exception && e.toString().isNotEmpty
                ? e.toString()
                : 'Unknown error');
      throw HttpError(message, 500);
    }
  }
}

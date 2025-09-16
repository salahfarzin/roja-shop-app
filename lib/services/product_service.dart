import 'dart:convert';
import 'package:rojashop/models/product.dart';
import '../utils/api_client.dart';

class ProductService {
  final ApiClient _client = ApiClient();

  /// Creates a product, uploading image if local file, and only including non-empty fields.
  Future<Product> createProduct(
    Map<String, dynamic> data, {
    void Function(double progress)? onProgress,
  }) async {
    // Remove null or empty fields
    final filtered = <String, String>{};
    data.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      if (key == 'details' || key == 'style_notes') {
        if (value is Map && value.isNotEmpty) {
          filtered[key] = jsonEncode(value);
        }
        return;
      }
      if (value is num || value is int || value is double) {
        filtered[key] = value.toString();
        return;
      }
      filtered[key] = value.toString();
    });

    String? imagePath = data['image'];
    bool isLocalImage =
        imagePath != null &&
        imagePath.isNotEmpty &&
        !imagePath.startsWith('http');

    final response = await _client.multipartRequest(
      '/products',
      fields: filtered,
      fileField: isLocalImage ? 'image' : null,
      filePath: isLocalImage ? imagePath : null,
      onProgress: onProgress,
    );

    return Product.fromJson(response['product'] as Map<String, dynamic>);
  }

  /// Updates a product, uploading image if local file, and only including non-empty fields.
  Future<Product> updateProduct(
    String id,
    Map<String, dynamic> data, {
    void Function(double progress)? onProgress,
  }) async {
    // Remove null or empty fields
    final filtered = <String, String>{};
    data.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      if (key == 'details' || key == 'style_notes') {
        if (value is Map && value.isNotEmpty) {
          filtered[key] = jsonEncode(value);
        }
        return;
      }
      if (value is num || value is int || value is double) {
        filtered[key] = value.toString();
        return;
      }
      filtered[key] = value.toString();
    });

    String? imagePath = data['image'];
    bool isLocalImage =
        imagePath != null &&
        imagePath.isNotEmpty &&
        !imagePath.startsWith('http');

    // Always use multipart for update, with or without image
    final response = await _client.multipartRequest(
      '/products/$id',
      method: 'PUT',
      fields: filtered,
      fileField: isLocalImage ? 'image' : null,
      filePath: isLocalImage ? imagePath : null,
      onProgress: onProgress,
      headers: {'Content-Type': 'application/json'},
    );
    return Product.fromJson(response['product'] as Map<String, dynamic>);
  }

  Future<dynamic> sellProduct(String id) async {
    final response = await _client.request(
      '/products/sell/$id',
      method: 'POST',
      body: {'uuid': id, 'quantity': 1},
      headers: {'Content-Type': 'application/json'},
    );

    return Product.fromJson(response['product'] as Map<String, dynamic>);
  }

  Future<List<Product>> fetchProducts({int page = 0, int limit = 6}) async {
    // Pass page/limit as query params if backend supports
    final response = await _client.request(
      '/products?page=$page&limit=$limit',
      headers: {'Content-Type': 'application/json'},
    );
    if (response == null || response is! List) {
      return <Product>[];
    }
    final products = response
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList()
        .cast<Product>();
    return products;
  }
}

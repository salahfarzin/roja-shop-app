import 'dart:convert';
import 'package:rojashop/models/product.dart';
import '../utils/api_client.dart';

class ProductService {
  final ApiClient _client = ApiClient();

  /// Creates a product, uploading image if local file, and only including non-empty fields.
  Future<Product> createProduct(Map<String, dynamic> data) async {
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
    );
    return Product.fromJson(response as Map<String, dynamic>);
  }

  Future<dynamic> sellProduct(String uuid) async {
    return await _client.request(
      '/products/sell',
      method: 'POST',
      body: {'uuid': uuid},
    );
  }

  Future<List<Product>> fetchProducts() async {
    final response = await _client.request('/products');
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

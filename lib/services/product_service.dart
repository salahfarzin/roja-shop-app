import 'package:rojashop/models/product.dart';

import '../utils/api_client.dart';

class ProductService {
  final ApiClient _client = ApiClient();

  Future<dynamic> sellProduct(String uuid) async {
    return await _client.request(
      '/products/sell',
      method: 'POST',
      body: {'uuid': uuid},
    );
  }

  Future<List<Product>> fetchProducts() async {
    final response = await _client.request('/products');
    final products = (response as List)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
    return products;
  }
}

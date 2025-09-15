import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../data/products.dart';
import '../utils/http_error.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _products = const [];
  ProductStatus _status = ProductStatus.initial;
  String? _errorMessage;

  /// Exposes an unmodifiable view of the products list
  List<Product> get products => List.unmodifiable(_products);
  ProductStatus get status => _status;
  String? get errorMessage => _errorMessage;

  /// Fetches products from the server or local demo data.
  /// Notifies listeners on state changes.
  Future<void> fetchProducts({bool demo = false}) async {
    _status = ProductStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      if (demo) {
        await Future.delayed(const Duration(milliseconds: 500));
        _products = productsData;
      } else {
        final fetched = await _service.fetchProducts();
        _products = fetched;
      }
      _status = ProductStatus.loaded;
    } catch (e) {
      _status = ProductStatus.error;
      if (e is HttpError) {
        _errorMessage = 'Failed to load products: ${e.message}';
      } else {
        _errorMessage = 'Failed to load products: $e';
      }
    }
    notifyListeners();
  }

  /// Sends a sell request for a product by id and returns the sold count.
  Future<int?> sellProduct(String productId) async {
    try {
      final response = await _service.sellProduct(productId);
      notifyListeners();
      if (response is Map<String, dynamic> && response.containsKey('count')) {
        return response['count'] as int?;
      }
      return null;
    } catch (e) {
      notifyListeners();
      return null;
    }
  }
}

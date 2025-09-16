import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../data/products.dart';
import '../utils/http_error.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider with ChangeNotifier {
  Future<Product?> updateProduct(
    String id,
    Map<String, dynamic> data, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final updated = await _service.updateProduct(
        id,
        data,
        onProgress: onProgress,
      );
      // Update local list
      _products = _products.map((p) => p.id == id ? updated : p).toList();
      notifyListeners();
      return updated;
    } catch (e) {
      String message = 'Failed to update product';
      if (e is HttpError) {
        _errorMessage = '$message: ${e.message}';
      } else {
        _errorMessage = '$message: $e';
      }
      notifyListeners();
      return null;
    }
  }

  final ProductService _service = ProductService();

  List<Product> _products = const [];
  ProductStatus _status = ProductStatus.initial;
  String? _errorMessage;

  /// Exposes an unmodifiable view of the products list
  List<Product> get products => List.unmodifiable(_products);
  ProductStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<Product?> addProduct(
    Map<String, dynamic> data, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final product = await _service.createProduct(
        data,
        onProgress: onProgress,
      );

      _products = [..._products, product];

      notifyListeners();

      return product;
    } catch (e) {
      String message = 'Failed to add product';
      // If error is an HttpError, show code and message
      if (e is HttpError) {
        _errorMessage = '$message: ${e.message}';
      } else {
        _errorMessage = '$message: $e';
      }
      notifyListeners();
      return null;
    }
  }

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

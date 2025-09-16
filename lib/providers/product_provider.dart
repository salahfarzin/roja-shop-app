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

  /// Fetches products with pagination (offset, limit)
  Future<void> fetchMoreProducts({
    int page = 0,
    int limit = 6,
    bool demo = false,
  }) async {
    _status = ProductStatus.loading;
    _errorMessage = null;

    try {
      List<Product> newProducts;
      if (demo) {
        // Demo mode: slice from local data
        newProducts = productsData.skip(page * limit).take(limit).toList();
      } else {
        // Real API: implement paginated fetch in ProductService
        newProducts = await _service.fetchProducts(page: page, limit: limit);
      }
      if (page == 0) {
        _products = newProducts;
      } else {
        _products = [..._products, ...newProducts];
      }
      _status = ProductStatus.loaded;
      notifyListeners();
    } catch (e) {
      String message = 'Failed to fetch products';
      if (e is HttpError) {
        _errorMessage = '$message: ${e.message}';
      } else {
        _errorMessage = '$message: $e';
      }
      _status = ProductStatus.error;
      notifyListeners();
    }
  }

  Future<Product?> sellProduct(String productId) async {
    try {
      final product = await _service.sellProduct(productId);
      // Update local list with new product data
      _products = _products
          .map((p) => p.id == productId ? product : p)
          .toList()
          .cast<Product>();
      notifyListeners();
      return product;
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }
}

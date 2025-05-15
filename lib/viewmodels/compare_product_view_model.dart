import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CompareProductViewModel extends ChangeNotifier {
  final List<Product> _comparedProducts = [];
  static const int maxComparedProducts = 4; // Limit number of compared products

  // Getter to expose the list of compared products
  List<Product> get comparedProducts => _comparedProducts;

  // Check if more products can be added (limit is 4)
  bool get canAddMoreProducts => _comparedProducts.length < maxComparedProducts;

  // Add a product to the comparison list with validation
  void addProduct(Product product) {
    if (!canAddMoreProducts) {
      throw Exception('Maximum number of compared products reached');
    }

    if (_comparedProducts.any((p) => p.id == product.id)) {
      throw Exception('Product already added');
    }

    if (_comparedProducts.isNotEmpty) {
      final categoryId = _comparedProducts.first.categoryId;
      if (product.categoryId != categoryId) {
        throw Exception('Only products from the same category can be compared');
      }
    }

    // Add product and notify listeners if not already in list
    if (!_comparedProducts.any((p) => p.id == product.id)) {
      _comparedProducts.add(product);
      notifyListeners();
    }
  }

  // Remove a product by its ID and notify listeners
  void removeProduct(int productId) {
    _comparedProducts.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  // Clear all compared products and notify listeners
  void clearComparison() {
    _comparedProducts.clear();
    notifyListeners();
  }

  // Check if a product is already in comparison list
  bool isProductInComparison(int productId) {
    return _comparedProducts.any((p) => p.id == productId);
  }
}

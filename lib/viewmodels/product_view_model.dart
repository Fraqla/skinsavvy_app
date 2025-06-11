import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products => _searchQuery.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> fetchProductsByCategory(int categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.getProductsByCategory(categoryId);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(_searchQuery) ||
            (product.brand?.toLowerCase().contains(_searchQuery) ?? false) ||
            (product.description.toLowerCase().contains(_searchQuery));
      }).toList();
    }
    notifyListeners();
  }
}

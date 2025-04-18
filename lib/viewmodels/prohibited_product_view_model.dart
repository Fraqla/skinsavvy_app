import 'package:flutter/material.dart';
import '../models/prohibited_product_model.dart';
import '../services/api_service.dart';


class ProhibitedProductViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<ProhibitedProductModel> _prohibitedProducts = [];
  bool isLoading = false;
  String? error;

  List<ProhibitedProductModel> get prohibitedProducts => _prohibitedProducts;

  Future<void> fetchProhibitedProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _prohibitedProducts = await _apiService.getProhibitedProducts();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

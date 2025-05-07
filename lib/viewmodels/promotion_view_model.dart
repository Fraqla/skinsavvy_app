import 'package:flutter/material.dart';
import '../models/promotion_model.dart';
import '../services/api_service.dart';

class PromotionViewModel extends ChangeNotifier {
  List<PromotionModel> _promotions = [];
  bool _isLoading = false;
  String? _error;

  List<PromotionModel> get promotions => _promotions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPromotions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().getPromotions();
      _promotions = response
          .where((promo) => promo.isActive) // Only show active promotions
          .toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load promotions: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
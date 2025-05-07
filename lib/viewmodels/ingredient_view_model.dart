import 'package:flutter/material.dart';
import '../models/ingredient_model.dart';
import '../services/api_service.dart'; // Import your service

class IngredientViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<IngredientModel> _ingredients = [];

  List<IngredientModel> get ingredients => _ingredients;

  Future<void> fetchIngredients() async {
    try {
      _ingredients = await _apiService.getIngredients();
      notifyListeners();
    } catch (e) {
      print('Error fetching ingredients: $e');
    }
  }
}

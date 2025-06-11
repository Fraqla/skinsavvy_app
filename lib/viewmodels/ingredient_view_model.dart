import 'package:flutter/material.dart';
import '../models/ingredient_model.dart';
import '../services/api_service.dart';

class IngredientViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<IngredientModel> _ingredients = [];
  List<IngredientModel> _filteredIngredients = [];

  List<IngredientModel> get ingredients => _filteredIngredients;

  Future<void> fetchIngredients() async {
    try {
      _ingredients = await _apiService.getIngredients();
      _filteredIngredients = _ingredients;
      notifyListeners();
    } catch (e) {
      print('Error fetching ingredients: $e');
    }
  }

  void searchIngredients(String query) {
    if (query.isEmpty) {
      _filteredIngredients = _ingredients;
    } else {
      _filteredIngredients = _ingredients
          .where((ingredient) =>
              ingredient.ingredientName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

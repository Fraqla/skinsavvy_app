import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/ingredient_model.dart';

class IngredientViewModel extends ChangeNotifier {
  List<IngredientModel> _ingredients = [];

  List<IngredientModel> get ingredients => _ingredients;

  Future<void> fetchIngredients() async {
    const url = 'http://your-laravel-api.test/api/ingredients'; // Adjust with your actual API route

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _ingredients = data
            .map((json) => IngredientModel.fromJson(json))
            .toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      print('Error fetching ingredients: $e');
    }
  }
}

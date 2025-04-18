import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/promotion_model.dart';

class PromotionViewModel extends ChangeNotifier {
  List<PromotionModel> _promotions = [];

  List<PromotionModel> get promotions => _promotions;

  Future<void> fetchPromotions() async {
    const url = 'http://your-laravel-api.test/api/promotions'; // Adjust with your actual API route

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _promotions = data
            .map((json) => PromotionModel.fromJson(json))
            .toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load promotions');
      }
    } catch (e) {
      print('Error fetching promotions: $e');
    }
  }
}

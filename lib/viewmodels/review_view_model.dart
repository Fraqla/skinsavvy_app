import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review_model.dart';
import '../services/api_service.dart';

class ReviewViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<Review> _reviews = [];
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  List<Review> get reviews => _reviews;
  bool get isAuthenticated => _isAuthenticated;

  // Add this method to check authentication status
  Future<void> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getString('authToken') != null;
    notifyListeners();
  }

  Future<void> fetchReviews(int productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reviews = await _apiService.getReviews(productId);
      print('Fetched ${_reviews.length} reviews'); // Debug print
    } catch (e) {
      print('Error fetching reviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReview(
    int productId,
    String comment,
    double rating, [
    File? photo,
    Uint8List? webImage,
  ]) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _apiService.addReview(
        productId,
        comment,
        rating,
        photo,
        webImage,
      );
      await fetchReviews(productId);
    } catch (e) {
      print('Error adding review: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

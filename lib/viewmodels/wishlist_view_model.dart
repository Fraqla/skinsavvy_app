import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skinsavvy_app/models/product_model.dart';
import '../models/wishlist_model.dart';
import '../services/api_service.dart';

class WishlistViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<WishlistItem> _wishlist = [];
  bool isLoading = false;
  String? error;

  List<WishlistItem> get wishlist => _wishlist;

  Future<void> fetchWishlist() async {
    isLoading = true;
    notifyListeners();

    try {
      _wishlist = await _apiService.getUserWishlist();
    } catch (e) {
      print("Error loading wishlist: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToWishlist( Product product) async {
  isLoading = true;
  notifyListeners();

  try {
    final response = await _apiService.addToWishlist(product);
    print("Add to wishlist response: ${response.statusCode} - ${response.body}");

if (response.statusCode >= 200 && response.statusCode < 300) {
  await fetchWishlist();
  return true;
} else {
  final Map<String, dynamic> responseBody = json.decode(response.body);
  error = responseBody['message'] ?? 'Failed to add item to wishlist';
  return false;
}

  } catch (e) {
    error = "Error adding item: $e";
    print("Exception in addToWishlist: $e");
    return false;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}



  

 Future<void> removeFromWishlist(String productId, String userId) async {
  isLoading = true;
  notifyListeners();

  try {
    final response = await _apiService.removeFromWishlist(productId, userId);
    print("Remove wishlist response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      _wishlist.removeWhere((item) => item.product.id.toString() == productId);
      notifyListeners();
    } else {
      error = "Failed to remove item from wishlist";
    }
  } catch (e) {
    error = "Error removing item: $e";
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

}

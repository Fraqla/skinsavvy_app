import 'package:flutter/material.dart';
import '../models/wishlist_item.dart';
import '../services/api_service.dart';

class WishlistViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<WishlistItem> _wishlist = [];
  bool isLoading = false;

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
}

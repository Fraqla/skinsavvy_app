// viewmodels/tips_view_model.dart
import 'package:flutter/material.dart';
import '../models/tips_model.dart';
import '../services/api_service.dart';

class TipsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Tip> _tips = [];
  bool _isLoading = false;
  String? _error;

  List<Tip> get tips => _tips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tips = await _apiService.getTips();
    } catch (e) {
      _error = 'Failed to load tips';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

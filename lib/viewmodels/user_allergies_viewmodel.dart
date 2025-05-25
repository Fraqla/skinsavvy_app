import 'package:flutter/material.dart';
import '../models/user_allergy_model.dart';
import '../services/api_service.dart';

class UserAllergiesViewModel with ChangeNotifier {
  final ApiService _apiService;
  List<UserAllergy> _allergies = [];
  bool _isLoading = false;
  String? _error;

  UserAllergiesViewModel(this._apiService);

  List<UserAllergy> get allergies => _allergies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllergies() async {
    try {
      _isLoading = true;
      // Don't notify here to avoid build conflict
      
      _allergies = await _apiService.getUserAllergies();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify only after complete
    }
  }

  Future<void> addAllergy(String ingredient) async {
    if (ingredient.trim().isEmpty) return;
    
    try {
      _isLoading = true;
      notifyListeners();
      
      final newAllergy = await _apiService.addUserAllergy(ingredient);
      _allergies.add(newAllergy);
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> removeAllergy(String ingredient) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _apiService.removeUserAllergy(ingredient);
      _allergies.removeWhere((a) => a.ingredientName == ingredient);
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
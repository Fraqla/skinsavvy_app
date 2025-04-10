  // view_models/login_view_model.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  Future<bool> login(String email, String password) async {
  _isLoading = true;
  notifyListeners();

  try {
    final loggedInUser = await ApiService().login(email: email, password: password);

    _isLoading = false;
    _user = loggedInUser;
    notifyListeners();
    return true;

  } catch (e) {
    // Catch API errors and show them in debug log or UI
    debugPrint("Login Error: $e");

    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  void logout() {
    _user = null;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService;

  // Auth state
  UserModel? _currentUser;
  bool _isAuthLoading = false;
  String? _authError;

  // Registration state
  bool _isRegisterLoading = false;
  bool _isRegisterSuccess = false;
  String? _registerError;

  AuthViewModel({required ApiService apiService}) : _apiService = apiService;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Auth state getters
  bool get isAuthLoading => _isAuthLoading;
  String? get authError => _authError;

  // Registration state getters
  bool get isRegisterLoading => _isRegisterLoading;
  bool get isRegisterSuccess => _isRegisterSuccess;
  String? get registerError => _registerError;

  // Login method
Future<bool> login(String email, String password, BuildContext context) async {
  _isAuthLoading = true;
  _authError = null;
  notifyListeners();

  try {
    final user = await _apiService.login(email: email, password: password, context: context); // Corrected here
    _currentUser = user;
    return true; // Success
  } catch (e) {
    _authError = e.toString();
    _currentUser = null;
    return false; // Failure
  } finally {
    _isAuthLoading = false;
    notifyListeners();
  }
}


  // Register method
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isRegisterLoading = true;
    _registerError = null;
    _isRegisterSuccess = false;
    notifyListeners();

    try {
      // Call the registration API
      final user = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );
      _currentUser = user;
      _isRegisterSuccess = true;
    } catch (e) {
      _registerError = e.toString();
      _isRegisterSuccess = false;
      rethrow;
    } finally {
      _isRegisterLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  void logout() {
    _currentUser = null;
    // Optionally, clear the session from local storage (e.g., SharedPreferences)
    notifyListeners();
  }

  // Optionally, you can add session management here, like checking if the user is already logged in
  Future<void> checkSession() async {
    // Check if there is an active session (e.g., stored token or user data)
    // If yes, fetch user details and set _currentUser
  }
}

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService;
  
  // Auth state
  UserModel? _currentUser;
  bool _isAuthLoading = false; // Corrected variable name
  String? _authError;
  
  // Registration state
  bool _isRegisterLoading = false;
  bool _isRegisterSuccess = false;
  String? _registerError;

  AuthViewModel({required ApiService apiService}) : _apiService = apiService;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  
  // Auth getters
  bool get isAuthLoading => _isAuthLoading; // Fixed getter
  String? get authError => _authError;
  
  // Registration getters
  bool get isRegisterLoading => _isRegisterLoading;
  bool get isRegisterSuccess => _isRegisterSuccess;
  String? get registerError => _registerError;

  // Login method
  Future<void> login(String email, String password) async {
    _isAuthLoading = true; // Fixed variable name
    _authError = null;
    notifyListeners();

// TODO: Implement actual login API call
    try {
      _currentUser = UserModel(name: "Demo User", email: email);
    } catch (e) {
      _authError = e.toString();
      rethrow;
    } finally {
      _isAuthLoading = false; // Fixed variable name
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
      _currentUser = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );
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

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
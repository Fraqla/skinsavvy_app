// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  String? _authToken;
  String? _userId;

  String? get authToken => _authToken;
  String? get userId => _userId;
  bool get isAuthenticated => _authToken != null;

  Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('authToken');
    _userId = prefs.getString('userId');
    notifyListeners();
  }

  Future<void> setAuthData(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('userId', userId);
    _authToken = token;
    _userId = userId;
    notifyListeners();
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userId');
    _authToken = null;
    _userId = null;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserViewModel extends ChangeNotifier {
  final ApiService apiService;
  final String token;  // Pass user auth token

  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  UserViewModel({required this.apiService, required this.token});

  Future<void> loadUserProfile() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedUser = await apiService.fetchUserProfile(token);
      _user = fetchedUser;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await apiService.updateUserProfile(token, updatedUser);
      _user = updated;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

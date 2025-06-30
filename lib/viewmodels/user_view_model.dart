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
  notifyListeners();

  try {
    _user = await apiService.fetchUserProfile(token);
    print('Loaded user skin type: ${_user?.userSkinType?.skinType}'); // Debug
    notifyListeners();
  } catch (e) {
    _error = e.toString();
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

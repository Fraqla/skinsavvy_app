// view_models/login_view_model.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/services/auth_provider.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../models/user_skin_type_model.dart'; // Make sure to import UserSkinType

class LoginViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  String? _token;

  UserModel? get user => _user;
  String? get token => _token;

  Future<bool> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loggedInUser = await apiService.login(
        email: email,
        password: password,
        context: context,
      );

      final authService = Provider.of<AuthService>(context, listen: false);
      _token = await authService.getToken();
      _user = loggedInUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
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

  // Add this new method to update just the skin type
  void updateUserSkinType(UserSkinType? skinType) {
    if (_user != null) {
      _user = _user!.copyWith(userSkinType: skinType);
      notifyListeners();
    }
  }

  Future<void> updateUser({required String name, required String email}) async {
    if (_user == null) return;

    final updatedUser = _user!.copyWith(
      name: name,
      email: email,
    );

    try {
      final newUser = await apiService.updateUserProfile(_token!, updatedUser);
      _user = newUser;
      notifyListeners();
    } catch (e) {
      debugPrint("Update user error: $e");
      rethrow;
    }
  }
}
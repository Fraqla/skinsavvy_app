  // view_models/login_view_model.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
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
    final loggedInUser = await ApiService().login(email: email, password: password, context: context);

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

  Future<void> updateUser({required String name, required String email}) async {
  if (_token == null || _user == null) throw Exception('User not logged in');

  final updatedUser = UserModel(
    id: _user!.id,
    name: name,
    email: email,
    userSkinType: _user!.userSkinType,
    // include any other required fields
  );

  try {
    final result = await ApiService().updateUserProfile(_token!, updatedUser);
    _user = result;
    notifyListeners();
  } catch (e) {
    rethrow;
  }
}

}

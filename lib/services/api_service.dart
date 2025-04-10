import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skinsavvy_app/models/user_model.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform.isAndroid

class ApiService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api'; // Web browser (same machine)
    } else if (Platform.isAndroid) {
      // Check if running on emulator or physical device
      final bool isEmulator = Platform.environment['EMULATOR'] == 'true';
      return isEmulator 
          ? 'http://10.0.2.2:8000/api' // Android emulator
          : 'http://10.211.107.40:8000/api'; // Physical Android device
    } else {
      return 'http://10.211.107.40:8000/api'; // iOS/other platforms
    }
  }

Future<UserModel> register({
  required String name,
  required String email,
  required String password,
}) async {
  final response = await http.post(
  Uri.parse('$baseUrl/register'),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'Flutter', // Add this header
  },
  body: jsonEncode({
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': password,
  }),
);

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return UserModel.fromJson(data['user']);
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Registration failed');
  }
}
}

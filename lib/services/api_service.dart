import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skinsavvy_app/models/category_model.dart' as models;  // Alias 'Category' as 'models'
import 'package:skinsavvy_app/models/user_model.dart'; 
import 'package:skinsavvy_app/models/product_model.dart'; 
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/tips_model.dart';

class ApiService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      final bool isEmulator = Platform.environment['EMULATOR'] == 'true';
      return isEmulator 
          ? 'http://10.0.2.2:8000/api'
          : 'http://10.211.107.40:8000/api';
    } else {
      return 'http://10.211.107.40:8000/api';
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
        'X-Requested-With': 'Flutter',
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

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'Flutter',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['user']);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Login failed');
    }
  }

Future<List<models.Category>> getCategories() async {
  final response = await http.get(
    Uri.parse('$baseUrl/categories'),
    headers: {'Accept': 'application/json'},
  );

  // Print the raw API response for debugging
  // print('Raw API Response: ${response.body}');

  if (response.statusCode == 200) {
    // Directly decode the response as a list of categories
    final List<dynamic> data = jsonDecode(response.body);

    // Map the data to Category models
    return data.map((json) => models.Category.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}

Future<List<Product>> getProductsByCategory(int categoryId) async {
  final response = await http.get(Uri.parse('$baseUrl/products?category_id=$categoryId'));

  if (response.statusCode == 200) {
    // Decode the response body
    final Map<String, dynamic> data = jsonDecode(response.body);

    // Access the 'data' field which contains the products
    final List<dynamic> productsData = data['data'];

    // Return a list of products by mapping the response to Product.fromJson
    return productsData.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products by category');
  }
}

 Future<List<Tip>> getTips() async {
    final response = await http.get(Uri.parse('$baseUrl/tips'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Tip.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tips');
    }
  }

}


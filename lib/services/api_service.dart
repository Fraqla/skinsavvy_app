import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Add this import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsavvy_app/models/category_model.dart' as models;
import '../models/ingredient_model.dart';
import 'package:skinsavvy_app/models/user_model.dart';
import 'package:skinsavvy_app/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/tips_model.dart';
import '../models/skin_knowledge_model.dart';
import '../models/prohibited_product_model.dart';
import '../models/promotion_model.dart';
import '../models/skin_quiz_model.dart';
import '../models/wishlist_item.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class ApiService {
  late BuildContext _context;

  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://localhost:8000/api';
    }
  }

  ApiService();

  // New method to set context when needed
  void setContext(BuildContext context) {
    _context = context;
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
    required BuildContext context,
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

      // ✅ Store token and user ID using AuthService
      final token = data['token']; // Make sure your backend returns this
      final userId = data['user']['id'].toString(); // Ensure it's a string

      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.setAuthData(token, userId);

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
    final response =
        await http.get(Uri.parse('$baseUrl/products?category_id=$categoryId'));

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

  Future<List<SkinKnowledgeModel>> getSkinKnowledge() async {
    final response = await http.get(Uri.parse('$baseUrl/skin-knowledge'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SkinKnowledgeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load skin knowledge');
    }
  }

  Future<List<ProhibitedProductModel>> getProhibitedProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/prohibited-products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProhibitedProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load prohibited products');
    }
  }

  Future<List<IngredientModel>> getIngredients() async {
    final response = await http.get(Uri.parse('$baseUrl/ingredients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => IngredientModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ingredient list');
    }
  }

  Future<List<PromotionModel>> getPromotions() async {
    final response = await http.get(Uri.parse('$baseUrl/promotions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PromotionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load promotion list');
    }
  }

  Future<List<SkinQuizModel>> getSkinQuizzes() async {
    final response = await http.get(Uri.parse('$baseUrl/skin-quizzes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => SkinQuizModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  Future<String> submitSkinQuizAnswers(
      List<Map<String, dynamic>> answers) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/submit-skin-quiz'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'answers': answers,
        }),
      );

      // Check if the response status code is successful
      if (response.statusCode == 200) {
        // Parse the response JSON and extract 'skin_type'
        final data = json.decode(response.body);
        return data['skin_type'] ??
            'unknown'; // Return 'unknown' if skin_type is not found
      } else {
        // Handle the case where the server responds with an error status
        throw Exception(
            'Failed to submit answers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any errors (e.g., network issues) and rethrow or log them
      throw Exception('Failed to submit answers. Error: $e');
    }
  }

  Future<http.Response> addToWishlist(
      String userId, Product product, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId,
        'product_id': product.id,
      }),
    );

    return response;
  }

  Future<List<WishlistItem>> getUserWishlist() async {
    final response = await http.post(Uri.parse('$baseUrl/wishlist'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      return (decoded['wishlist'] as List)
          .map((item) => WishlistItem.fromJson(item))
          .toList();
    } else {
      throw Exception("Failed to fetch wishlist");
    }
  }

  Future<Map<String, String>> _getHeaders({bool withAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      if (_context == null) {
        throw Exception('Context not set for authenticated request');
      }
      final authService = Provider.of<AuthService>(_context!, listen: false);
      final token = authService.authToken;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}

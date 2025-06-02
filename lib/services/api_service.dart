import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Add this import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsavvy_app/models/category_model.dart' as models;
import 'package:skinsavvy_app/models/review_model.dart';
import 'package:skinsavvy_app/models/user_allergy_model.dart';
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
import '../models/wishlist_model.dart';
import '../models/review_model.dart';
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
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> productsData = data['data'];
      return productsData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> productsData = data['data'];
      return productsData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all products');
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
    try {
      final response = await http.get(Uri.parse('$baseUrl/skin-quizzes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((e) {
          try {
            return SkinQuizModel.fromJson(e);
          } catch (innerError) {
            print('Failed to parse quiz item: $e');
            print('Error: $innerError');
            throw Exception('Invalid quiz format.');
          }
        }).toList();
      } else {
        throw Exception(
            'Failed to load quizzes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getSkinQuizzes: $e');
      rethrow;
    }
  }

Future<Map<String, dynamic>> submitSkinQuizAnswers(
    List<Map<String, dynamic>> answers, String token) async {
  print('Submitting answers: ${jsonEncode(answers)}');

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/skin-quizzes/submit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'answers': answers}),
    );

    print('Response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print('User ID: ${responseJson['user_id']}');
      print('Skin Type: ${responseJson['skin_type']}');
      print('Total Score: ${responseJson['total_score']}');

      print('Quiz submitted successfully');

      return responseJson; // ✅ Return the response to the caller
    } else {
      print('Failed to submit quiz: ${response.statusCode} ${response.body}');
      throw Exception('Failed to submit quiz: ${response.body}');
    }
  } catch (e) {
    print('Error submitting quiz: $e');
    rethrow;
  }
}


  Future<http.Response> addToWishlist(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final userId = prefs.getString('userId');

    if (token == null || userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'product_id': product.id,
        'user_id': userId,
      }),
    );

    return response;
  }

  Future<List<WishlistItem>> getUserWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final response = await http.get(
      Uri.parse('$baseUrl/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    // Print the raw response body to see what the server is returning
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return (decoded as List)
          .map((item) => WishlistItem.fromJson(item))
          .toList();
    } else {
      throw Exception("Failed to fetch wishlist: ${response.body}");
    }
  }

// Remove an item from the wishlist
  Future<http.Response> removeFromWishlist(
      String wishlistItemId, String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    return await http.delete(
      Uri.parse('$baseUrl/wishlist/$wishlistItemId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  Future<List<Review>> getReviews(int productId) async {
    final res = await http.get(Uri.parse('$baseUrl/reviews/$productId'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> addReview(
    int productId,
    String comment,
    double rating, [
    File? photo,
    Uint8List? webImage,
  ]) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('User not authenticated');
    }

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/reviews'));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['product_id'] = productId.toString();
    request.fields['review'] = comment;
    request.fields['rating'] = rating.toString();

    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    } else if (webImage != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'photo',
        webImage,
        filename: 'review_image.jpg',
      ));
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final responseData = jsonDecode(respStr);

    if (response.statusCode == 201) {
      return; // Success case
    } else {
      throw Exception(
          'Failed to add review: ${responseData['message'] ?? 'Unknown error'}');
    }
  }

  Future<List<UserAllergy>> getUserAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) throw Exception('Not authenticated');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-allergies'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) return []; // Handle empty response
        return data.map((json) => UserAllergy.fromJson(json)).toList();
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMsg = errorBody['message'] ?? 'Failed to load allergies';
        throw Exception('$errorMsg (${response.statusCode})');
      }
    } on FormatException {
      throw Exception('Invalid server response format');
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<UserAllergy> addUserAllergy(String ingredient) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/user-allergies'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'ingredient_name': ingredient}),
    );

    if (response.statusCode == 201) {
      return UserAllergy.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add allergy: ${response.statusCode}');
    }
  }

  Future<void> removeUserAllergy(String ingredient) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) throw Exception('Not authenticated');

    final response = await http.delete(
      Uri.parse('$baseUrl/user-allergies/${Uri.encodeComponent(ingredient)}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove allergy: ${response.statusCode}');
    }
  }

Future<UserModel> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['user'] ?? data); // Handle both wrapped and unwrapped responses
    } else {
      throw Exception('Failed to load user profile');
    }
}

Future<UserModel> updateUserProfile(String token, UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': user.name,
        'email': user.email,
        'skin_type': user.skinType?.toJson(),
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['user'] ?? data);
    } else {
      throw Exception('Failed to update user profile');
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

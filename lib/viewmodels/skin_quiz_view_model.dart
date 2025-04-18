import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/skin_quiz_model.dart';

class SkinQuizViewModel extends ChangeNotifier {
  List<SkinQuizModel> _skinQuizzes = [];

  List<SkinQuizModel> get skinQuizzes => _skinQuizzes;

  Future<void> fetchSkinQuizzes() async {
    const url = 'http://your-laravel-api.test/api/skin-quizzes'; // adjust your API route

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _skinQuizzes = data
            .map((json) => SkinQuizModel.fromJson(json))
            .toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load skin quizzes');
      }
    } catch (e) {
      print('Error fetching skin quizzes: $e');
    }
  }
}

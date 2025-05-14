import 'package:flutter/material.dart';
import '../models/skin_quiz_model.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';

class SkinQuizViewModel extends ChangeNotifier {
  final ApiService _apiService;
  List<SkinQuizModel> _skinQuizzes = [];
  int _currentQuestionIndex = 0;
  Map<int, String> _userAnswers = {};
  bool _isLoading = false;
  String? _error;
  String? _skinTypeResult;
  int _totalScore = 0;

  SkinQuizViewModel(BuildContext context) : _apiService = ApiService() {
    _apiService.setContext(context);
  }

  List<SkinQuizModel> get skinQuizzes => _skinQuizzes;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get skinTypeResult => _skinTypeResult;
  SkinQuizModel? get currentQuestion =>
      _currentQuestionIndex < _skinQuizzes.length
          ? _skinQuizzes[_currentQuestionIndex]
          : null;

Future<void> fetchSkinQuizzes() async {
  _isLoading = true;
  notifyListeners();

  try {
    _skinQuizzes = await _apiService.getSkinQuizzes();
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _totalScore = 0;
    _skinTypeResult = null;  // Ensure this is only reset if user starts a new quiz
    _error = null;
  } catch (e) {
    _error = 'Failed to load quiz. Please try again.';
  }

  _isLoading = false;
  notifyListeners();
}



  Future<void> answerQuestion(String answer, int score) async {
  _userAnswers[currentQuestionIndex] = answer;
  _totalScore += score;

  // If it's the last question, calculate the result
  if (_currentQuestionIndex < _skinQuizzes.length - 1) {
    _currentQuestionIndex++;
  } else {
    await _submitAnswers(); // Submit answers without the userId
  }
  notifyListeners();
}

Future<void> _submitAnswers() async {
  _isLoading = true;
  notifyListeners();

  try {
    final answers = _userAnswers.entries
        .map((e) => {
              'quiz_id': _skinQuizzes[e.key].id,
              'answer': e.value,
            })
        .toList();

    // Save the user's answers to the database (without userId)
    await _apiService.submitSkinQuizAnswers(answers);

    // Calculate the result based on the total score
    _skinTypeResult = _calculateSkinType(_totalScore);
    _error = null;

    // Notify listeners to update the UI
    notifyListeners();
  } catch (e) {
    _error = 'Failed to submit answers. Please try again.';
    notifyListeners();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}



  String _calculateSkinType(int score) {
    if (score >= 5 && score <= 7) {
      return 'Dry Skin';
    } else if (score >= 8 && score <= 10) {
      return 'Oily Skin';
    } else if (score >= 11 && score <= 13) {
      return 'Normal Skin';
    } else if (score >= 14 && score <= 20) {
      return 'Combination Skin';
    } else {
      return 'Unknown Skin Type';
    }
  }

void resetQuiz() {
  _currentQuestionIndex = 0;
  _userAnswers.clear();
  _totalScore = 0;
  _skinTypeResult = null;
  _error = null;
  notifyListeners();
}


}

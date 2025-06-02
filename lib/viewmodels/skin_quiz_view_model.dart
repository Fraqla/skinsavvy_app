import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/skin_quiz_model.dart';
import '../services/api_service.dart';

class SkinQuizViewModel extends ChangeNotifier {
  final ApiService _apiService;
  List<SkinQuizModel> _skinQuizzes = [];
  int _currentQuestionIndex = 0;
  Map<int, String> _userAnswers = {};
  bool _isLoading = false;
  String? _error;
  String? _skinTypeResult;
  int _totalScore = 0;
  bool _isAuthenticated = false;
  String _token = '';

  SkinQuizViewModel(BuildContext context) : _apiService = ApiService() {
    _apiService.setContext(context);
    _loadToken();
  }

  // Getters
  List<SkinQuizModel> get skinQuizzes => _skinQuizzes;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get skinTypeResult => _skinTypeResult;
  int get totalScore => _totalScore;
  bool get isAuthenticated => _isAuthenticated;
  SkinQuizModel? get currentQuestion =>
      _currentQuestionIndex < _skinQuizzes.length
          ? _skinQuizzes[_currentQuestionIndex]
          : null;

  // Token loading
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken') ?? '';
  }

  Future<void> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getString('authToken') != null;
    notifyListeners();
  }

  Future<void> fetchSkinQuizzes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _skinQuizzes = await _apiService.getSkinQuizzes();
      _currentQuestionIndex = 0;
      _userAnswers.clear();
      _totalScore = 0;
      _skinTypeResult = null;
      _error = null;
    } catch (e) {
      _error = 'Failed to load quiz. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> answerQuestion(String answer, int score) async {
    _userAnswers[currentQuestionIndex] = answer;

    if (_currentQuestionIndex < _skinQuizzes.length - 1) {
      _currentQuestionIndex++;
    } else {
      await _submitAnswers();
    }

    notifyListeners();
  }

  Future<void> _submitAnswers() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token.isEmpty) {
        await _loadToken();
      }

      final answers = _userAnswers.entries
          .map((e) => {
                'quiz_id': _skinQuizzes[e.key].id,
                'user_answer': e.value,
                'score': _skinQuizzes[e.key].answers
                    .firstWhere((ans) => ans.text == e.value)
                    .score,
              })
          .toList();

      final responseJson =
          await _apiService.submitSkinQuizAnswers(answers, _token);

      _skinTypeResult = responseJson['skin_type'];
      _totalScore = responseJson['total_score'];
      _error = null;
    } catch (e) {
      _error = 'Failed to submit answers. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
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

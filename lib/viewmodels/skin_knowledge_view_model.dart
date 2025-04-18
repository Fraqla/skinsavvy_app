import 'package:flutter/material.dart';
import '../models/skin_knowledge_model.dart';
import '../services/api_service.dart';

class SkinKnowledgeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<SkinKnowledgeModel> _knowledgeList = [];
  bool _isLoading = false;
  String? _error;

  List<SkinKnowledgeModel> get knowledgeList => _knowledgeList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSkinKnowledge() async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    _knowledgeList = await _apiService.getSkinKnowledge();
  } catch (e) {
    _error = 'Failed to load skin knowledge: ${e.toString()}'; // Capture full error
    debugPrint('Error fetching skin knowledge: $e'); // Print to console
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}

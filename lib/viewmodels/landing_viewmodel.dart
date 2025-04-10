import 'package:flutter/foundation.dart';

class LandingViewModel with ChangeNotifier {
  int _currentIndex = 0;
  
  int get currentIndex => _currentIndex;
  
  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
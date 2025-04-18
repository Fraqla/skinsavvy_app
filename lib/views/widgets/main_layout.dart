import 'package:flutter/material.dart';
import 'package:skinsavvy_app/views/content/content_view.dart';
import '../landing_view.dart';
import '../categories_view.dart';
import '../content/tips/tips_view.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const MainLayout({super.key, required this.body, required this.currentIndex});

  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LandingView()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ContentView()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TipsView()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTabTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Content'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Tips'),
        ],
      ),
    );
  }
}

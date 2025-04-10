import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/viewmodels/auth_viewmodel.dart';
import 'package:skinsavvy_app/viewmodels/landing_viewmodel.dart';
import 'package:skinsavvy_app/widgets/skincare_card.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final landingViewModel = Provider.of<LandingViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkinSavvy'),
        actions: [
          if (!authViewModel.isLoggedIn)
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
        ],
      ),
      body: _buildBody(authViewModel),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: landingViewModel.currentIndex,
        onTap: landingViewModel.changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }

  Widget _buildBody(AuthViewModel authViewModel) {
    if (authViewModel.isLoggedIn) {
      return _buildDashboard();
    } else {
      return _buildGuestView();
    }
  }

  Widget _buildDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Skin Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: const [
              SkincareCard(title: 'Skin Type', icon: Icons.face),
              SkincareCard(title: 'Concerns', icon: Icons.warning),
              SkincareCard(title: 'Routine', icon: Icons.checklist),
              SkincareCard(title: 'Progress', icon: Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Discover Your Perfect Skincare', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Image.asset('assets/skincare_welcome.png', height: 200),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Get Started', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/category_model.dart';
import '../models/tips_model.dart';
import '../services/api_service.dart';
import '../viewmodels/login_view_model.dart';
import '../views/categories_view.dart';
import 'product/category_products_view.dart';
import 'login_view.dart';
import 'content/tips/tips_view.dart';
import 'widgets/main_layout.dart';
import 'product/user_allergies_view.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  List<Category> _categories = [];
  List<Tip> _tips = [];
  bool _isCategoriesLoading = true;
  bool _isTipsLoading = true;
  String? _categoriesError;
  String? _tipsError;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTips();
  }

  Future<void> _fetchCategories() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final categories = await apiService.getCategories();
      
      if (mounted) {
        setState(() {
          _categories = categories;
          _isCategoriesLoading = false;
          _categoriesError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCategoriesLoading = false;
          _categoriesError = 'Failed to load categories';
        });
      }
    }
  }

  Future<void> _fetchTips() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final tips = await apiService.getTips();
      
      if (mounted) {
        setState(() {
          _tips = tips;
          _isTipsLoading = false;
          _tipsError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTipsLoading = false;
          _tipsError = 'Failed to load tips';
        });
      }
    }
  }

  Widget _buildCategoryItem(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductsView(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: (category.imageUrl != null && category.imageUrl.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: "http://localhost:8000/category-image/${category.imageUrl.split('/').last}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                    )
                  : const Center(child: Icon(Icons.image_not_supported)),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    if (_isTipsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tipsError != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_tipsError!),
            ElevatedButton(
              onPressed: _fetchTips,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Skincare Tips',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TipsView()),
                  );
                },
                child: const Text('See all', style: TextStyle(color: Colors.pink)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: _tips.isEmpty
              ? const Center(child: Text('No tips available'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _tips.length > 3 ? 3 : _tips.length,
                  itemBuilder: (context, index) {
                    final tip = _tips[index];
                    return _buildTipCard(tip);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTipCard(Tip tip) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: "http://localhost:8000/tip-image/${tip.imageUrl.split('/').last}",
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tip.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyAlertCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserAllergiesView()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.pink[100]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.orange),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Allergy Alert',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    Text(
                      'Tap to manage ingredients you\'re allergic to',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.pink),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return MainLayout(
      currentIndex: 0,
      body: Scaffold(
        appBar: AppBar(
          title: const Text('SkinSavvy'),
          centerTitle: true,
          actions: [
            if (loginVM.user == null)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginView()),
                  );
                },
                child: const Text("Login", style: TextStyle(color: Colors.white)),
              )
            else
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.warning_amber, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserAllergiesView()),
                      );
                    },
                    tooltip: 'My Allergies',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Hi, ${loginVM.user!.name}",
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () => loginVM.logout(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: 20,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome to SkinSavvy 🌸",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Discover the best skincare products for your skin.",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                // Categories Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Category',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CategoriesView(),
                            ),
                          );
                        },
                        child: const Text('See all', style: TextStyle(color: Colors.pink)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: _isCategoriesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _categoriesError != null
                          ? Center(child: Text(_categoriesError!))
                          : _categories.isEmpty
                              ? const Center(child: Text('No categories available'))
                              : ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  children: _categories
                                      .take(4)
                                      .map((category) => _buildCategoryItem(category))
                                      .toList(),
                                ),
                ),
                // Tips Section
                _buildTipsSection(),
                // Allergy reminder for logged-in users
                if (loginVM.user != null) _buildAllergyAlertCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
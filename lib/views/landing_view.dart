import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import '../viewmodels/login_view_model.dart';
import '../views/categories_view.dart';
import '../views/category_products_view.dart'; // Make sure this is the correct path
import 'login_view.dart'; // You'll create this

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

Future<void> _fetchCategories() async {
  try {
    final categories = await ApiService().getCategories();
    print(categories);  // Log the categories to check the response
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    print('Error fetching categories: $e');  // Log any errors
  }
}


  Widget _categoryItem(Category category) {
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
          // Replace Icon with Image
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
            child: category.imageUrl != null
                ? Image.network(
                    "http://localhost:8000/image/${category.imageUrl.split('/').last}", // Assuming category.imageUrl gives the correct path
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  )
                : const Center(child: Icon(Icons.image_not_supported)),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkinSavvy'),
        actions: [
          if (loginVM.user == null)
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginView()));
              },
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Hi, ${loginVM.user!.name}",
                      style: const TextStyle(color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      loginVM.logout();
                    },
                  )
                ],
              ),
            ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
                    const Text('Category', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoriesView(),
                          ),
                        );
                      },
                      child: const Text('See all', 
                          style: TextStyle(color: Colors.pink)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: _categories
                            .take(4) // Only show first 3 categories
                            .map((category) => _categoryItem(category))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

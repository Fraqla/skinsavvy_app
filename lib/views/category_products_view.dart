import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';  // Assuming you have a Product model

class CategoryProductsView extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsView({super.key, required this.categoryId, required this.categoryName,});

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  List<Product> _products = [];  // List of products in the category
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    try {
      final products = await ApiService().getProductsByCategory(widget.categoryId); // Adjust for API call
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products in Category'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to Product details page
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Image.asset(
                        //   product.imagePath, // Make sure Product has this field
                        //   width: 80,
                        //   height: 80,
                        //   errorBuilder: (context, error, stackTrace) =>
                        //       const Icon(Icons.image, size: 60),
                        // ),
                        Text(
                          product.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '\$${product.price}',  // Assuming Product has price
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/views/product/wishlist_view.dart';
import '../../models/product_model.dart';
import '../../services/auth_provider.dart';
import '../../services/api_service.dart';
import '../../viewmodels/wishlist_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/login_view.dart'; // Assuming this is the Login view you mentioned

class ProductDetailsView extends StatelessWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  final authService =
                      Provider.of<AuthService>(context, listen: false);

                  // Check if the user is logged in
                  if (authService.userId == null) {
                    // If not logged in, prompt to log in
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Please log in'),
                          content: const Text(
                              'You need to be logged in to view your wishlist.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Navigate to the Login View
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginView()),
                                );
                              },
                              child: const Text('Log in'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // If logged in, navigate to the Wishlist Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WishlistView()),
                    );
                  }
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: Image.network(
                  "http://localhost:8000/product-image/${product.imageUrl.split('/').last}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.compare_arrows,
                          label: 'Compare',
                          onPressed: () {
                            // Compare product functionality
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.reviews,
                          label: 'Reviews',
                          onPressed: () {
                            // Reviews functionality
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description Section
                  _buildSectionTitle('Description'),
                  Text(
                    product.description ?? 'No description available',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  // Ingredients Section
                  _buildSectionTitle('Ingredients'),
                  Text(
                    product.ingredient ?? 'Ingredients not specified',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  // Effects Section
                  Row(
                    children: [
                      Expanded(
                        child: _buildEffectCard(
                          title: 'Positive Effects',
                          effects: const [
                            'Hydrates skin',
                            'Reduces wrinkles',
                            'Brightens complexion'
                          ],
                          color: Colors.green[100],
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildEffectCard(
                          title: 'Negative Effects',
                          effects: const [
                            'May cause dryness',
                            'Possible irritation',
                            'Not for sensitive skin'
                          ],
                          color: Colors.red[100],
                          iconColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Add to Wishlist Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final wishlistVM = Provider.of<WishlistViewModel>(
                            context,
                            listen: false);

                        final success = await wishlistVM.addToWishlist(product);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to wishlist')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to add to wishlist. Please try again.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'ADD TO WISHLIST',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildEffectCard({
    required String title,
    required List<String> effects,
    required Color? color,
    required Color? iconColor,
  }) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  title.contains('Positive')
                      ? Icons.thumb_up
                      : Icons.thumb_down,
                  color: iconColor,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: effects
                  .map((effect) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const SizedBox(width: 24),
                            Expanded(
                              child: Text(
                                '• $effect',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

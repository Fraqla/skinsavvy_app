import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product_model.dart';
import '../../services/auth_provider.dart';
import '../../viewmodels/compare_product_view_model.dart';
import '../../viewmodels/wishlist_view_model.dart';
import '../../views/login_view.dart';
import '../../views/product/compare_product_view.dart';
import '../../views/product/wishlist_view.dart';

class ProductDetailsView extends StatelessWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductTitle(product.name),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Description'),
                  Text(
                    product.description ?? 'No description available',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Ingredients'),
                  Text(
                    product.ingredient ?? 'Ingredients not specified',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  _buildEffectsSection(),
                  const SizedBox(height: 24),
                  _buildWishlistButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            final authService =
                Provider.of<AuthService>(context, listen: false);
            if (authService.userId == null) {
              _showLoginPrompt(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistView()),
              );
            }
          },
        ),
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
    );
  }

  Widget _buildProductTitle(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOutlinedAction(
            icon: Icons.compare_arrows,
            label: 'Compare',
            onPressed: () {
              final compareVM = Provider.of<CompareProductViewModel>(
                context,
                listen: false,
              );
              compareVM.addProduct(product);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CompareProductView(categoryId: product.categoryId),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildOutlinedAction(
            icon: Icons.reviews,
            label: 'Reviews',
            onPressed: () {
              // Future: Add review logic
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOutlinedAction({
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEffectsSection() {
    return Row(
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
            ...effects.map(
              (effect) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    Expanded(
                      child: Text(
                        '• $effect',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final wishlistVM =
              Provider.of<WishlistViewModel>(context, listen: false);
          final success = await wishlistVM.addToWishlist(product);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Added to wishlist'
                    : 'Failed to add to wishlist. Please try again.',
              ),
            ),
          );
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Please log in'),
        content: const Text('You need to be logged in to view your wishlist.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
              );
            },
            child: const Text('Log in'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

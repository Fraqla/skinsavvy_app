import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/services/api_service.dart';
import '../../models/product_model.dart';
import '../../services/auth_provider.dart';
import '../../viewmodels/compare_product_view_model.dart';
import '../../viewmodels/wishlist_view_model.dart';
import '../../views/login_view.dart';
import '../../views/product/compare_product_view.dart';
import '../../views/product/wishlist_view.dart';
import '../../views/product/review_product_view.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  String _selectedEffectType = 'Benefits';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(context),
                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 24),
                  _buildProductDescription(),
                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 24),
                  _buildIngredientsSection(),
                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 24),
                  _buildEffectsSection(),
                  const SizedBox(height: 32),
                  _buildWishlistButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Hero(
          tag: 'product-${widget.product.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                "${apiService.baseStorageUrl}/products/${widget.product.imageUrl.split('/').last}",
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.purple,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.purple,
            ),
          ),
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
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductTitle(),
        const SizedBox(height: 16),
        _buildProductMeta(),
        const SizedBox(height: 20),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildProductTitle() {
    return Text(
      widget.product.name,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.3,
      ),
    );
  }

  Widget _buildProductMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.product.brand != null && widget.product.brand!.isNotEmpty)
          _buildMetaItem(
            icon: Icons.branding_watermark,
            label: widget.product.brand!,
          ),
        if (widget.product.suitability != null &&
            widget.product.suitability!.isNotEmpty)
          _buildMetaItem(
            icon: Icons.face_retouching_natural,
            label: widget.product.suitability!,
          ),
      ],
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.purple),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.compare_arrows,
            label: 'Compare',
            color: Colors.blue,
            onPressed: () {
              final compareVM = Provider.of<CompareProductViewModel>(
                context,
                listen: false,
              );
              compareVM.addProduct(widget.product);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CompareProductView(categoryId: widget.product.categoryId),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.reviews,
            label: 'Reviews',
            color: Colors.amber,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReviewView(productId: widget.product.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildProductDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Description'),
        const SizedBox(height: 12),
        Text(
          widget.product.description ?? 'No description available',
          style: TextStyle(
            fontSize: 11,
            height: 1.6,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Key Ingredients'),
        const SizedBox(height: 12),
        Text(
          widget.product.ingredient ?? 'Ingredients not specified',
          style: TextStyle(
            fontSize: 11,
            height: 1.6,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildEffectsSection() {
    List<String> safeDecode(String? jsonStr) {
      try {
        if (jsonStr == null || jsonStr.isEmpty) return [];
        final decoded = jsonDecode(jsonStr);
        if (decoded is List) return decoded.map((e) => e.toString()).toList();
        return [];
      } catch (e) {
        return [];
      }
    }

    final positiveEffects = safeDecode(widget.product.positive);
    final negativeEffects = safeDecode(widget.product.negative);

    final effects =
        _selectedEffectType == 'Benefits' ? positiveEffects : negativeEffects;
    final icon = _selectedEffectType == 'Benefits'
        ? Icons.verified
        : Icons.warning_amber_rounded;
    final color = _selectedEffectType == 'Benefits'
        ? Colors.green[50]
        : Colors.orange[50];
    final textColor = _selectedEffectType == 'Benefits'
        ? Colors.green[800]
        : Colors.orange[800];
    final borderColor = _selectedEffectType == 'Benefits'
        ? Colors.green[100]
        : Colors.orange[100];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Product Effects'),
        const SizedBox(height: 16),

        // Segmented control for Benefits/Considerations
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => _selectedEffectType = 'Benefits'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedEffectType == 'Benefits'
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _selectedEffectType == 'Benefits'
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        'Benefits',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _selectedEffectType == 'Benefits'
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: _selectedEffectType == 'Benefits'
                              ? Colors.green[800]
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () =>
                      setState(() => _selectedEffectType = 'Considerations'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedEffectType == 'Considerations'
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _selectedEffectType == 'Considerations'
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        'Considerations',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _selectedEffectType == 'Considerations'
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: _selectedEffectType == 'Considerations'
                              ? Colors.orange[800]
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Effects content
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor!, width: 1.5),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: textColor?.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: textColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedEffectType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (effects.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No ${_selectedEffectType.toLowerCase()} information available',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else
                Column(
                  children: effects
                      .map(
                        (effect) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                child: Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  effect,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final authService = Provider.of<AuthService>(context, listen: false);
          if (authService.userId == null) {
            _showLoginPrompt(context);
            return;
          }

          final wishlistVM =
              Provider.of<WishlistViewModel>(context, listen: false);
          final success = await wishlistVM.addToWishlist(widget.product);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success ? 'Added to wishlist' : 'Failed to add to wishlist',
                style: const TextStyle(fontSize: 12),
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: Colors.purple.withOpacity(0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 22),
            SizedBox(width: 10),
            Text(
              'ADD TO WISHLIST',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Login Required',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You need to log in to save products to your wishlist.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
              );
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }
}

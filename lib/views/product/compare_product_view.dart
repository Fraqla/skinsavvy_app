import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/services/api_service.dart';
import '../../viewmodels/compare_product_view_model.dart';
import '../../models/product_model.dart';

class CompareProductView extends StatelessWidget {
  final int categoryId;
  const CompareProductView({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compareVM = Provider.of<CompareProductViewModel>(context);
    final products = compareVM.comparedProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Comparison'),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (products.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear all',
              onPressed: () => _showClearConfirmationDialog(context, compareVM),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: products.isEmpty
            ? _buildEmptyState(context)
            : _buildComparisonTable(compareVM, products, context, categoryId),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context, compareVM, categoryId),
        child: const Icon(Icons.compare_arrows),
        tooltip: 'Add product to compare',
        backgroundColor: theme.primaryColor,
        elevation: 4,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.compare_rounded,
              size: 80, color: theme.primaryColor.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            'No Products to Compare',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.disabledColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add products to start comparing their features, ingredients, and benefits.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () => _showAddProductDialog(
                context,
                Provider.of<CompareProductViewModel>(context, listen: false),
                categoryId),
            child: const Text('Add First Product'),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(
    CompareProductViewModel compareVM,
    List<Product> products,
    BuildContext context,
    int categoryId,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: theme.hintColor),
              const SizedBox(width: 8),
              Text(
                'Comparing ${products.length} ${products.length == 1 ? 'product' : 'products'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const Spacer(),
              if (compareVM.canAddMoreProducts)
                TextButton.icon(
                  onPressed: () =>
                      _showAddProductDialog(context, compareVM, categoryId),
                  icon: Icon(Icons.add, size: 18),
                  label: const Text('Add Another'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = min(280.0, constraints.maxWidth / 2);
                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildAttributeColumn(context, cardWidth),
                    const SizedBox(width: 12),
                    ...products.map((product) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildProductCard(
                              compareVM, product, context, cardWidth),
                        )),
                    if (compareVM.canAddMoreProducts)
                      _buildAddProductCard(context, compareVM, categoryId,
                          width: cardWidth),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttributeColumn(BuildContext context, double width) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 225), // Image height
              Divider(color: theme.dividerColor.withOpacity(0.3)),
              const SizedBox(height: 20), // Product name height
              Text('PRODUCT',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.hintColor,
                    letterSpacing: 1,
                  )),
              const SizedBox(height: 60), // Ingredients height
              Text('INGREDIENTS',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.hintColor,
                    letterSpacing: 1,
                  )),
              const SizedBox(height: 70), // Suitability height
              Text('SUITABILITY',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.hintColor,
                    letterSpacing: 1,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(CompareProductViewModel compareVM, Product product,
      BuildContext context, double width) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fixed height image container
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  // Centered image container
                  Center(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: SizedBox(
                        width:
                            300, // Match the height to maintain square aspect ratio
                        height: 400,
                        child: Image.network(
                          "${apiService.baseStorageUrl}/products/${product.imageUrl.split('/').last}",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade100,
                            child: Center(
                              child: Icon(Icons.broken_image,
                                  size: 40, color: Colors.grey.shade400),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white.withOpacity(0.9),
                      shape: const CircleBorder(),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => compareVM.removeProduct(product.id),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(Icons.close,
                              size: 18, color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                  if (product.brand != null && product.brand!.isNotEmpty)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.brand!.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Fixed height content sections
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name with fixed height
                    SizedBox(
                      height: 70,
                      child: Text(
                        product.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ingredients with scrollable content
                    _buildComparisonRow(
                      context,
                      value: product.ingredient,
                    ),
                    const SizedBox(height: 25),

                    // Suitability with fixed height
                    SizedBox(
                      height: 32,
                      child: product.suitability != null &&
                              product.suitability!.isNotEmpty
                          ? _buildSuitabilityChip(product.suitability!, context)
                          : const SizedBox.shrink(),
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

  Widget _buildComparisonRow(BuildContext context,
      {required String value}) {
    final theme = Theme.of(context);
    return Container(
      height: 72, // Fixed height to maintain consistent row heights
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value.isNotEmpty ? value : 'No ingredients listed',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuitabilityChip(String suitability, BuildContext context) {
    final theme = Theme.of(context);
    final color = suitability.toLowerCase().contains('sensitive')
        ? Colors.blue
        : suitability.toLowerCase().contains('dry')
            ? Colors.orange
            : suitability.toLowerCase().contains('oily')
                ? Colors.green
                : theme.primaryColor;

    return Chip(
      label: Text(
        suitability,
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
        ),
      ),
      backgroundColor: color.withOpacity(0.8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildAddProductCard(
    BuildContext context,
    CompareProductViewModel compareVM,
    int categoryId, {
    required double width,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.dividerColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showAddProductDialog(context, compareVM, categoryId),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline,
                    size: 40, color: theme.primaryColor),
                const SizedBox(height: 12),
                Text(
                  'Add Product',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to select',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddProductDialog(
    BuildContext context,
    CompareProductViewModel compareVM,
    int categoryId,
  ) {
    final searchController = TextEditingController();
    List<Product> filteredProducts = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.compare_arrows),
                          const SizedBox(width: 6),
                          Text(
                            'Add Product to Compare',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: searchController,
                        style: const TextStyle(fontSize: 6),
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: FutureBuilder<List<Product>>(
                          future:
                              _fetchProducts(context, categoryId: categoryId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Failed to load products',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            }

                            final allProducts = snapshot.data ?? [];
                            final searchTerm =
                                searchController.text.toLowerCase();

                            filteredProducts = allProducts
                                .where((product) =>
                                    product.name
                                        .toLowerCase()
                                        .contains(searchTerm) ||
                                    product.description
                                        .toLowerCase()
                                        .contains(searchTerm))
                                .where((product) => !compareVM
                                    .isProductInComparison(product.id))
                                .toList();

                            if (filteredProducts.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search_off,
                                        size: 48,
                                        color: Theme.of(context).hintColor),
                                    const SizedBox(height: 16),
                                    Text(
                                      searchTerm.isEmpty
                                          ? 'No products available'
                                          : 'No matching products found',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: min(filteredProducts.length, 5),
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return _buildProductListItem(
                                    context, product, compareVM);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductListItem(BuildContext context, Product product,
      CompareProductViewModel compareVM) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            "${apiService.baseStorageUrl}/products/${product.imageUrl.split('/').last}",
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: FilledButton.tonal(
          onPressed: () {
            try {
              compareVM.addProduct(product);
              Navigator.pop(context);
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size(40, 40),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Icon(Icons.add, size: 20),
        ),
      ),
    );
  }

  Future<List<Product>> _fetchProducts(BuildContext context,
      {int? categoryId}) async {
    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      if (categoryId != null && categoryId > 0) {
        return await apiService.getProductsByCategory(categoryId);
      } else {
        return await apiService.getAllProducts();
      }
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  void _showClearConfirmationDialog(
      BuildContext context, CompareProductViewModel compareVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Comparison?'),
        content: const Text(
            'This will remove all products from the comparison. Do you want to continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              compareVM.clearComparison();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
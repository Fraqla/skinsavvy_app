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
    final compareVM = Provider.of<CompareProductViewModel>(context);
    final products = compareVM.comparedProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Products'),
        centerTitle: true,
        actions: [
          if (products.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear all',
              onPressed: () => _showClearConfirmationDialog(context, compareVM),
            ),
        ],
      ),
      body: products.isEmpty
          ? _buildEmptyState(context)
          : _buildComparisonTable(compareVM, products, context, categoryId),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context, compareVM, categoryId),
        child: const Icon(Icons.add),
        tooltip: 'Add product to compare',
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.compare_arrows,
              size: 64, color: Theme.of(context).primaryColor.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No products to compare',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add products',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).disabledColor,
            ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Comparing ${products.length} products',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAttributeColumn(context),
                  ...products.map((product) =>
                      _buildProductColumn(compareVM, product, context)),
                  if (compareVM.canAddMoreProducts)
                    _buildAddProductColumn(context, compareVM, categoryId),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttributeColumn(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text('PRODUCT NAME',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              )),
          const SizedBox(height: 16),
          Text('DESCRIPTION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              )),
          const SizedBox(height: 16),
          Text('INGREDIENTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              )),
        ],
      ),
    );
  }

  Widget _buildProductColumn(CompareProductViewModel compareVM, Product product,
      BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  "http://localhost:8000/product-image/${product.imageUrl.split('/').last}",
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(Icons.broken_image,
                          size: 40, color: Colors.grey.shade400),
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
                  child: IconButton(
                    icon: Icon(Icons.close,
                        size: 18, color: Colors.grey.shade700),
                    onPressed: () => compareVM.removeProduct(product.id),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  product.ingredient,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductColumn(
    BuildContext context,
    CompareProductViewModel compareVM,
    int categoryId,
  ) {
    return GestureDetector(
      onTap: () => _showAddProductDialog(context, compareVM, categoryId),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline,
                  size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                'Add Product',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
            return AlertDialog(
              title: const Text('Add Product to Compare'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: FutureBuilder<List<Product>>(
                        future: _fetchProducts(context, categoryId: categoryId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          final allProducts = snapshot.data ?? [];
                          final searchTerm =
                              searchController.text.toLowerCase();

                          // Filter products based on search term
                          filteredProducts = allProducts.where((product) {
                            return product.name
                                    .toLowerCase()
                                    .contains(searchTerm) ||
                                product.description
                                    .toLowerCase()
                                    .contains(searchTerm);
                          }).toList();

                          // Remove products already in comparison
                          filteredProducts.removeWhere((product) =>
                              compareVM.isProductInComparison(product.id));

                          if (filteredProducts.isEmpty) {
                            return const Center(
                                child: Text('No matching products found'));
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: min(filteredProducts.length,5),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      "http://localhost:8000/product-image/${product.imageUrl.split('/').last}",
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
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    product.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Theme.of(context).primaryColor),
                                    onPressed: () {
                                      try {
                                        compareVM.addProduct(product);
                                        Navigator.pop(context);
                                      } catch (e) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.toString()),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
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
        title: const Text('Clear Comparison'),
        content: const Text(
            'Are you sure you want to remove all products from comparison?'),
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
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

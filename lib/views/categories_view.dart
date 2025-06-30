import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/services/api_service.dart';

import '../viewmodels/category_view_model.dart';
import '../models/category_model.dart';
import 'product/category_products_view.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CategoryViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchCategories();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
    child: Consumer<CategoryViewModel>(
        builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return _buildLoadingState(context);
            } else if (viewModel.error != null) {
              return _buildErrorState(context, viewModel);
            } else if (viewModel.categories.isEmpty) {
              return _buildEmptyState(context);
            } else {
              return _buildCategoryGrid(context, viewModel.categories);
            }
          },
        ),
      ));
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(height: 16),
          Text('Loading Categories...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, CategoryViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Failed to load categories'),
          const SizedBox(height: 8),
          Text(viewModel.error ?? 'Unknown error'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => viewModel.fetchCategories(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No Categories Found'),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, List<Category> categories) {
  return AnimationLimiter(
    child: RefreshIndicator(
      onRefresh: () => context.read<CategoryViewModel>().fetchCategories(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildCategoryCard(context, categories[index], index);
            },
          );
        },
      ),
    ),
  );
}


  Widget _buildCategoryCard(BuildContext context, Category category, int index) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 500),
      columnCount: 2,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (_, __, ___) => CategoryProductsView(
                    categoryId: category.id,
                    categoryName: category.name,
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.primaries[index % Colors.primaries.length].shade100,
                      Colors.primaries[index % Colors.primaries.length].shade200,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Hero(
                          tag: 'category-image-${category.id}',
                          child: Image.network(
                            "${apiService.baseStorageUrl}/${category.imageUrl.split('/').last}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.category,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

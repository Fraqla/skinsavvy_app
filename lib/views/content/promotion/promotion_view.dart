import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/promotion_view_model.dart';
import 'promotion_detail_view.dart';

class PromotionView extends StatefulWidget {
  const PromotionView({super.key});

  @override
  State<PromotionView> createState() => _PromotionViewState();
}

class _PromotionViewState extends State<PromotionView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PromotionViewModel>(context, listen: false)
            .fetchPromotions());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Promotions'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<PromotionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }

          if (viewModel.promotions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_offer,
                      size: 60, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'No current promotions',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.promotions.length,
            itemBuilder: (context, index) {
              final promotion = viewModel.promotions[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PromotionDetailView(promotion: promotion),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'promotion-image-${promotion.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: promotion.imageUrl != null
                                ? Image.network(
                                    "http://localhost:8000/promotion-image/${promotion.imageUrl!.split('/').last}",
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 180,
                                      color: Colors.grey[200],
                                      child: const Center(
                                          child: Icon(Icons.broken_image)),
                                    ),
                                  )
                                : Container(
                                    height: 180,
                                    color: Colors.grey[200],
                                    child: const Center(
                                        child: Icon(Icons.image_not_supported)),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          promotion.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          promotion.dateRange,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          promotion.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View Details',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
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
      ),
    );
  }
}

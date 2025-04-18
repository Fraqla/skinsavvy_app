// views/promotion_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/promotion_view_model.dart';

class PromotionView extends StatelessWidget {
  const PromotionView({super.key});
 
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PromotionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Promotions')),
      body: FutureBuilder(
        future: viewModel.fetchPromotions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: viewModel.promotions.length,
            itemBuilder: (context, index) {
              final promotion = viewModel.promotions[index];
              return ListTile(
                title: Text(promotion.title),
                subtitle: Text(promotion.description),
                leading: promotion.image.isNotEmpty
                    ? Image.network(promotion.image, width: 50, height: 50)
                    : null,
                onTap: () {
                  // Navigate to promotion details or show more info
                },
              );
            },
          );
        },
      ),
    );
  }
}

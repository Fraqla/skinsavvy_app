// views/tips_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tips_view_model.dart';

class TipsView extends StatelessWidget {
  const TipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = TipsViewModel();
        viewModel.fetchTips();
        return viewModel;
      },
      child: Consumer<TipsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: const Text('Skincare Tips')),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.error != null
                    ? Center(child: Text(viewModel.error!))
                    : ListView.builder(
                        itemCount: viewModel.tips.length,
                        itemBuilder: (context, index) {
                          final tip = viewModel.tips[index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: Image.network(
                                "http://localhost:8000/tip-image/${tip.imageUrl.split('/').last}",
                                width: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                              title: Text(tip.title),
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}

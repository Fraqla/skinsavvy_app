import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/prohibited_product_view_model.dart';

class ProhibitedProductView extends StatefulWidget {
  const ProhibitedProductView({super.key});

  @override
  State<ProhibitedProductView> createState() => _ProhibitedProductViewState();
}

class _ProhibitedProductViewState extends State<ProhibitedProductView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProhibitedProductViewModel>(context, listen: false)
          .fetchProhibitedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Prohibited Products',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Consumer<ProhibitedProductViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (vm.error != null) {
            return Center(
              child: Text(vm.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16)),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.prohibitedProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = vm.prohibitedProducts[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.productName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('Detected Poison: ${product.detectedPoison}',
                                  style: const TextStyle(
                                      color: Colors.redAccent)),
                              const SizedBox(height: 6),
                              Text('Effect: ${product.effect}',
                                  style: const TextStyle(color: Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

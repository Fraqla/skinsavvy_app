import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/wishlist_view_model.dart';
import '../../models/wishlist_item.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Consumer<WishlistViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.wishlist.isEmpty) {
            return const Center(child: Text("Your wishlist is empty 💔"));
          }

          return ListView.builder(
            itemCount: vm.wishlist.length,
            itemBuilder: (context, index) {
              final item = vm.wishlist[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(item.imageUrl, width: 50, fit: BoxFit.cover),
                  title: Text(item.name),
                  subtitle: Text("RM ${item.price.toStringAsFixed(2)}"),
                  trailing: const Icon(Icons.favorite, color: Colors.pink),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

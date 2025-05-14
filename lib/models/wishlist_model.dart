import 'product_model.dart';

class WishlistItem {
  final int id;
  final int productId;
  final String name;
    final Product product;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.product,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    final product = json['product']; 

    return WishlistItem(
      id: json['id'],
      productId: product['id'],
      name: product['name'],
      product: Product.fromJson(json['product']),
    );
  }
}

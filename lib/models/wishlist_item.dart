class WishlistItem {
  final int id;
  final String name;
  final String imageUrl;
  final double price;

  WishlistItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'] ?? '', // Adjust field names based on your API
      price: json['price'].toDouble(),
    );
  }
}

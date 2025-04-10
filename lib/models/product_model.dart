class Product {
  final int id;
  final String name;
  // final String imagePath;
  final double price;

  Product({
    required this.id,
    required this.name,
    // required this.imagePath,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      // imagePath: json['image_path'] ?? 'assets/images/default.png',
      price: json['price']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        // 'image_path': imagePath,
        'price': price,
      };
}

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final String ingredient;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredient,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image'],
      description: json['description'],
      ingredient: json['ingredient'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'description': description,
        'ingredient': ingredient,
      };
}

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final String ingredient;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredient,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image'],
      description: json['description'],
      ingredient: json['ingredient'],
      categoryId: json['categoryId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'description': description,
        'ingredient': ingredient,
        'categoryId': categoryId,
      };
}

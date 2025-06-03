class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final String ingredient;
  final int categoryId;
  final String? positive; 
  final String? negative;
  final String? brand;
  final String? suitability;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredient,
    required this.categoryId,
    this.positive,
    this.negative,
    this.brand,
    this.suitability,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image'],
      description: json['description'],
      ingredient: json['ingredient'],
      categoryId: json['categoryId'] ?? 0,
      positive: json['positive'], 
      negative: json['negative'],
      brand: json['brand'],
      suitability: json['suitability'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'description': description,
        'ingredient': ingredient,
        'categoryId': categoryId,
        'positive': positive, 
        'negative': negative,
        'brand': brand, 
        'suitability': suitability,
      };
}

class IngredientModel {
  final int id;
  final String ingredientName;
  final String function;
  final List<String> facts;
  final List<String> benefits;
  final String imageUrl; // Changed from image to imageUrl

  IngredientModel({
    required this.id,
    required this.ingredientName,
    required this.function,
    required this.facts,
    required this.benefits,
    required this.imageUrl, // Changed from image to imageUrl
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'],
      ingredientName: json['ingredient_name'],
      function: json['function'],
      facts: List<String>.from(json['facts'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      imageUrl: json['image_url'], // Changed from image to image_url
    );
  }
}

class IngredientModel {
  final int id;
  final String ingredientName;
  final String function;
  final String facts;
  final String benefits;
  final String image;

  IngredientModel({
    required this.id,
    required this.ingredientName,
    required this.function,
    required this.facts,
    required this.benefits,
    required this.image,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'],
      ingredientName: json['ingredient_name'],
      function: json['function'],
      facts: json['facts'],
      benefits: json['benefits'],
      image: json['image'],
    );
  }
}

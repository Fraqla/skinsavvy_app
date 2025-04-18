class SkinKnowledgeModel {
  final int id;
  final String skinType;
  final List<String> characteristics;
  final List<String> bestIngredient;
  final String description;
  final String image;

  SkinKnowledgeModel({
    required this.id,
    required this.skinType,
    required this.characteristics,
    required this.bestIngredient,
    required this.description,
    required this.image,
  });

  factory SkinKnowledgeModel.fromJson(Map<String, dynamic> json) {
    return SkinKnowledgeModel(
      id: json['id'],
      skinType: json['skin_type'],
      characteristics: List<String>.from(json['characteristics']),
      bestIngredient: List<String>.from(json['best_ingredient']),
      description: json['description'],
      image: json['image'],
    );
  }
}

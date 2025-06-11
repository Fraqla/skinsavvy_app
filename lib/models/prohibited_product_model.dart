class ProhibitedProductModel {
  final int id;
  final String productName;
  final String detectedPoison;
  final String effect;
  final String image;
  final String? imageUrl; 

  ProhibitedProductModel({
    required this.id,
    required this.productName,
    required this.detectedPoison,
    required this.effect,
    required this.image,
    this.imageUrl,
  });

  factory ProhibitedProductModel.fromJson(Map<String, dynamic> json) {
    return ProhibitedProductModel(
      id: json['id'],
      productName: json['product_name'],
      detectedPoison: json['detected_poison'],
      effect: json['effect'],
      image: json['image'],
      imageUrl: json['image_url'],  
    );
  }
}

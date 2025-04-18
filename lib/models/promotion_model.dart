class PromotionModel {
  final int id;
  final String title;
  final String image;
  final String description;
  final String startEnd;
  final String endDate;

  PromotionModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.startEnd,
    required this.endDate,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      startEnd: json['start_end'],
      endDate: json['end_date'],
    );
  }
}

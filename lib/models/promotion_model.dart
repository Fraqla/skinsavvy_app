class PromotionModel {
  final int id;
  final String title;
  final String? imageUrl; // Changed from image to imageUrl
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  PromotionModel({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.description,
    required this.startDate,
    required this.endDate,
  }) : isActive = DateTime.now().isBefore(endDate);

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }

  String get dateRange {
    final start = '${startDate.day}/${startDate.month}/${startDate.year}';
    final end = '${endDate.day}/${endDate.month}/${endDate.year}';
    return '$start - $end';
  }
}
class Tip {
  final int id;
  final String title;
  final String imageUrl;
  final String description;

  Tip({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
      description: json['description'],
    );
  }
}

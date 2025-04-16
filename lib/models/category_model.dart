class Category {
  final int id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image_url'] ?? '', // Match key from Laravel
    );
  }
}

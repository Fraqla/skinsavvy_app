class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0, // Provide default value if null
      name: json['name'] ?? 'Unknown',
    );
  }

  // Optional: Add toJson method if you need to send data back
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

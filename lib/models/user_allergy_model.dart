class UserAllergy {
  final int id;
  final String ingredientName;
  final DateTime createdAt;

  UserAllergy({
    required this.id,
    required this.ingredientName,
    required this.createdAt,
  });

  factory UserAllergy.fromJson(Map<String, dynamic> json) {
    return UserAllergy(
      id: json['id'],
      ingredientName: json['ingredient_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredient_name': ingredientName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
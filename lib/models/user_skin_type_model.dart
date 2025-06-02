// user_skin_type_model.dart
class UserSkinType {
  final int id;
  final int userId;
  final int totalScore;
  final String skinType;

  UserSkinType({
    required this.id,
    required this.userId,
    required this.totalScore,
    required this.skinType,
  });

  factory UserSkinType.fromJson(Map<String, dynamic> json) {
    return UserSkinType(
      id: json['id'],
      userId: json['user_id'],
      totalScore: json['total_score'],
      skinType: json['skin_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_score': totalScore,
      'skin_type': skinType,
    };
  }
}

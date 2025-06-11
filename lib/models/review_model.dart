class Review {
  final int id;
  final int userId;
  final String review;
  final int rating;
  final String userName;
  final String? photo;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.review,
    required this.rating,
    required this.userName,
    this.photo,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      review: json['review'],
      rating: json['rating'],
      userName: json['user']['name'] ?? 'Anonymous',
      photo: json['photo'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}

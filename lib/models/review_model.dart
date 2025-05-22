class Review {
  final int id;
  final int userId;
  final String review;
  final int rating;
  final String userName;
  final String? photo;

  Review({
    required this.id,
    required this.userId,
    required this.review,
    required this.rating,
    required this.userName,
    this.photo,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      review: json['review'],
      rating: json['rating'],
      userName: json['user']['name'] ?? 'Anonymous',
      photo: json['photo'],
    );
  }
}

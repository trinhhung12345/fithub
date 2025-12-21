class Review {
  final int id;
  final int rating;
  final String comment;
  final int userId;
  final int productId;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.userId,
    required this.productId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? "",
      userId: json['userId'] ?? 0,
      productId: json['productId'] ?? 0,
    );
  }
}

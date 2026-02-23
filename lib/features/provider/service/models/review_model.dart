class ReviewModel {
  final String ownerName;
  final String ownerProfilePicture;
  final double rating;
  final String review;

  ReviewModel({
    required this.ownerName,
    required this.ownerProfilePicture,
    required this.rating,
    required this.review});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      ownerName: json['ownerName'] ?? '',
      ownerProfilePicture: json['ownerProfilePicture'] ?? '',
      rating: ((json['rating'] as num?) ?? 0).toDouble(),
      review: json['review'] ?? '',
    );
  }
}

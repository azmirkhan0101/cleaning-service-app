// Review Model
class ReviewModel {
  final String ownerName;
  final String ownerProfilePicture;
  final int rating;
  final String review;

  ReviewModel({
    required this.ownerName,
    required this.ownerProfilePicture,
    required this.rating,
    required this.review,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      ownerName: json['ownerName'] ?? '',
      ownerProfilePicture: json['ownerProfilePicture'] ?? '',
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
    );
  }
}

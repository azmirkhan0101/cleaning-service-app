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

var c = {
  "success": true,
  "message": "Service ratings and reviews retrieved successfully",
  "data": [
    {
      "ownerName": "Brikk Owner",
      "ownerProfilePicture":
          "https://res.cloudinary.com/dmanyahsz/image/upload/v1771472419/uploads/1771472418865_8favbf4cg9_1771472366995_compressed.jpg%22",
      "rating": 5,
      "review": "Goodgoooddoooddodod",
    },
  ],
};

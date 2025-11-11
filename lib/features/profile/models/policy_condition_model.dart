/*
{
    "success": true,
    "message": "About Us content retrieved successfully",
    "data": {
        "type": "aboutUs",
        "text": "Welcome to SparklePro Cleaning, your trusted partner for a spotless home and workspace — all at your fingertips.We created SparklePro with one simple mission: to make cleaning easy, reliable, and stress-free. Our app connects you with professional, background-checked cleaners who deliver top-quality service on your schedule. Whether it’s a quick home refresh, deep cleaning, or office maintenance, SparklePro ensures every space shines.With just a few taps, you can book, track, and manage all your cleaning appointments — no calls, no hassle, just clean.Our values are simple:✨ Quality you can trust – We partner only with skilled, trained cleaners who meet our high standards.⏰ Convenience first – Schedule cleanings anytime, anywhere through our easy-to-use app.💚 Care for every space – We use eco-friendly products and modern cleaning techniques to protect your home and the environment.🤝 Customer happiness – Your satisfaction is our top priority. If you’re not 100% happy, we’ll make it right.At SparklePro, we believe a clean space means a clear mind. Let us handle the mess — so you can focus on what matters most.",
        "createdAt": "2025-10-30T05:48:12.691Z",
        "updatedAt": "2025-10-30T05:48:12.691Z"
    }
}
*/

class PolicyConditionModel {
  final String type;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  PolicyConditionModel({
    required this.type,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PolicyConditionModel.fromJson(Map<String, dynamic> json) {
    return PolicyConditionModel(
      type: json['type'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

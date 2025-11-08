// Service Provider Details Model
class ServiceProviderDetailsModel {
  final String id;
  final String profilePicture;
  final String name; // renamed from userName (API now returns `name`)
  final String address;
  final String experience; // API may now return range string like "6-10"
  final String aboutMe;

  ServiceProviderDetailsModel({
    required this.id,
    required this.profilePicture,
    required this.name,
    required this.address,
    required this.experience,
    required this.aboutMe,
  });

  factory ServiceProviderDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderDetailsModel(
      id: json['_id'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      experience: json['experience'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
    );
  }

  // Backward-compatible getter for older UI references
  String get userName => name;

  /// Factory mapping for Booking Details API `data.provider`
  factory ServiceProviderDetailsModel.fromBookingJson(
    Map<String, dynamic> json,
  ) {
    return ServiceProviderDetailsModel(
      id: json['_id'] ?? json['id'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      experience: json['experience']?.toString() ?? '',
      aboutMe: json['aboutMe'] ?? '',
    );
  }
}

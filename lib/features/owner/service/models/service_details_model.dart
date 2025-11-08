// Service Details Model
class ServiceDetailsModel {
  final String id;
  final String name; // renamed from serviceName (API now returns `name`)
  final String oneImage; // renamed from coverImage (API now returns `oneImage`)
  final String rateByHour; // renamed from price (API now returns `rateByHour`)
  final double latitude;
  final double longitude;
  final double averageRatings;
  final int totalOrders;
  final bool
  instantBooking; // renamed from isApprovalRequired (API now returns `instantBooking` boolean)
  final String description;
  final List<String> photos;

  ServiceDetailsModel({
    required this.id,
    required this.name,
    required this.oneImage,
    required this.rateByHour,
    required this.latitude,
    required this.longitude,
    required this.averageRatings,
    required this.totalOrders,
    required this.instantBooking,
    required this.description,
    required this.photos,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      oneImage: json['oneImage'] ?? '',
      rateByHour: (json['rateByHour'] ?? '0').toString(),
      latitude: (json['lattitude'] ?? 0)
          .toDouble(), // backend still sends `lattitude`
      longitude: (json['longitude'] ?? 0).toDouble(),
      averageRatings: (json['averageRatings'] ?? 0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      instantBooking: json['instantBooking'] ?? false,
      description: json['description'] ?? '',
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  // Backward-compatible getters for older UI references
  String get serviceName => name;
  String get coverImage => oneImage;
  String get price => rateByHour;
  bool get isApprovalRequired => !instantBooking;
}

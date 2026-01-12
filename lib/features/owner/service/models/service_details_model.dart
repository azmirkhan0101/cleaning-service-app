// Service Details Model
double _asDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

int _asInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

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
  final List<PhotosModel> photos;

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
    final List<dynamic> rawPhotos = (json['photos'] as List<dynamic>?) ?? [];
    final dynamic approval = json['isApprovalRequired'];
    final bool instant =
        json['instantBooking'] ?? (approval is bool ? !approval : false);
    return ServiceDetailsModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? json['serviceName'] ?? '',
      oneImage: json['oneImage'] ?? json['coverImage'] ?? '',
      rateByHour: (json['rateByHour'] ?? json['price'] ?? '0').toString(),
      latitude: _asDouble(json['lattitude'] ?? json['latitude'] ?? 0),
      longitude: _asDouble(json['longitude'] ?? 0),
      averageRatings: _asDouble(
        json['averageRatings'] ?? json['ratingsAverage'] ?? 0,
      ),
      totalOrders: _asInt(json['totalOrders'] ?? 0),
      instantBooking: instant,
      description: json['description'] ?? '',
      photos: rawPhotos.map((e) => PhotosModel.fromJson(e)).toList(),
    );
  }

  // Backward-compatible getters for older UI references
  String get serviceName => name;
  String get coverImage => oneImage;
  String get price => rateByHour;
  bool get isApprovalRequired => !instantBooking;

  /// Factory mapping for Booking Details API `data.service`
  factory ServiceDetailsModel.fromBookingJson(Map<String, dynamic> json) {
    final List<dynamic> rawPhotos =
        (json['photos'] as List<dynamic>?) ??
        (json['allImages'] as List<dynamic>?) ??
        [];
    return ServiceDetailsModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      oneImage: json['oneImage'] ?? '',
      rateByHour: (json['rateByHour'] ?? '0').toString(),
      latitude: _asDouble(json['lattitude'] ?? json['latitude'] ?? 0),
      longitude: _asDouble(json['longitude'] ?? 0),
      averageRatings: _asDouble(
        json['averageRatings'] ?? json['ratingsAverage'] ?? 0,
      ),
      totalOrders: _asInt(json['totalOrders'] ?? 0),
      instantBooking: json['instantBooking'] ?? false,
      description: json['description'] ?? '',
      photos: rawPhotos.map((e) => PhotosModel.fromJson(e)).toList(),
    );
  }
}

class PhotosModel{

  final String imageUrl;
  final String id;

  PhotosModel({required this.imageUrl, required this.id});

  factory PhotosModel.fromJson(Map<String, dynamic> json) {
    return PhotosModel(
      imageUrl: json['url'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, String> toJson(){
    return {
      'url': imageUrl,
      'id': id,
    };
  }
}

// Service Details Model
class ServiceDetailsModel {
  final String id;
  final String serviceName;
  final String coverImage;
  final String price;
  final double latitude;
  final double longitude;
  final double averageRatings;
  final int totalOrders;
  final bool isApprovalRequired;
  final String description;
  final List<String> photos;

  ServiceDetailsModel({
    required this.id,
    required this.serviceName,
    required this.coverImage,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.averageRatings,
    required this.totalOrders,
    required this.isApprovalRequired,
    required this.description,
    required this.photos,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      coverImage: json['coverImage'] ?? '',
      price: json['price'] ?? '0',
      latitude: (json['lattitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      averageRatings: (json['averageRatings'] ?? 0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      isApprovalRequired: json['isApprovalRequired'] ?? false,
      description: json['description'] ?? '',
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

// Service Provider Details Model
class ServiceProviderDetailsModel {
  final String id;
  final String profilePicture;
  final String userName;
  final String address;
  final String experience;
  final String aboutMe;

  ServiceProviderDetailsModel({
    required this.id,
    required this.profilePicture,
    required this.userName,
    required this.address,
    required this.experience,
    required this.aboutMe,
  });

  factory ServiceProviderDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderDetailsModel(
      id: json['_id'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      userName: json['userName'] ?? '',
      address: json['address'] ?? '',
      experience: json['experience'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
    );
  }
}

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

// Schedule Day Model
class ScheduleDayModel {
  final String day;
  final bool isAvailable;
  final String startTime;
  final String endTime;

  ScheduleDayModel({
    required this.day,
    required this.isAvailable,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleDayModel.fromJson(Map<String, dynamic> json) {
    return ScheduleDayModel(
      day: json['day'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}

// Schedule Model
class ScheduleModel {
  final ScheduleDayModel monday;
  final ScheduleDayModel tuesday;
  final ScheduleDayModel wednesday;
  final ScheduleDayModel thursday;
  final ScheduleDayModel friday;
  final ScheduleDayModel saturday;
  final ScheduleDayModel sunday;

  ScheduleModel({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      monday: ScheduleDayModel.fromJson(json['monday'] ?? {}),
      tuesday: ScheduleDayModel.fromJson(json['tuesday'] ?? {}),
      wednesday: ScheduleDayModel.fromJson(json['wednesday'] ?? {}),
      thursday: ScheduleDayModel.fromJson(json['thursday'] ?? {}),
      friday: ScheduleDayModel.fromJson(json['friday'] ?? {}),
      saturday: ScheduleDayModel.fromJson(json['saturday'] ?? {}),
      sunday: ScheduleDayModel.fromJson(json['sunday'] ?? {}),
    );
  }

  List<ScheduleDayModel> get allDays => [
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  ];
}

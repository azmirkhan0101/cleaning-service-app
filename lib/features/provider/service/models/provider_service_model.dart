/*
{
  "_id": "690ae3ffe2d5ada4c8681075",
  "providerId": {
      "_id": "69098f6e94b24793ab08b0da",
      "userName": "Cleaner Test 1",
      "phoneNumber": "+8801584996987",
      "email": "provider1@yopmail.com",
      "profilePicture": "https://res.cloudinary.com/dmanyahsz/image/upload/v1764151456/profile-pictures/1764151456267_b5h1fpm5obb_profile_1764151291980.jpg",
      "plan": "SILVER",
      "badge": null
  },
  "categoryId": {
      "_id": "6927fc9b65c396b125c6c8a1",
      "name": "Test Category"
  },
  "name": "Coworking Space Cleaning",
  "description": "Daily cleaning service for coworking spaces and shared offices. Maintain a professional and hygienic environment for all users.",
  "rateByHour": "27.00",
  "needApproval": true,
  "gender": "Male",
  "languages": [
      "English"
  ],
  "coverImages": [
      "https://images.unsplash.com/photo-1497366216548-37526070297c?w=800",
      "https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=800",
      "https://images.unsplash.com/photo-1556761175-4b46a572b786?w=800"
  ],
  "workSchedule": {
      "monday": {
          "day": "Monday",
          "isAvailable": true,
          "startTime": "10:00",
          "endTime": "20:00"
      },
      "tuesday": {
          "day": "Tuesday",
          "isAvailable": false,
          "startTime": "",
          "endTime": ""
      },
      "wednesday": {
          "day": "Wednesday",
          "isAvailable": true,
          "startTime": "07:00",
          "endTime": "17:00"
      },
      "thursday": {
          "day": "Thursday",
          "isAvailable": true,
          "startTime": "10:00",
          "endTime": "19:00"
      },
      "friday": {
          "day": "Friday",
          "isAvailable": true,
          "startTime": "10:00",
          "endTime": "17:00"
      },
      "saturday": {
          "day": "Saturday",
          "isAvailable": true,
          "startTime": "08:00",
          "endTime": "18:00"
      },
      "sunday": {
          "day": "Sunday",
          "isAvailable": true,
          "startTime": "11:00",
          "endTime": "17:00"
      }
  },
  "ratingsAverage": 4.55,
  "ratingsCount": 6,
  "reviews": [],
  "totalOrders": 19,
  "createdAt": "2025-11-05T05:43:27.774Z",
  "updatedAt": "2025-12-30T10:52:32.465Z",
  "coverImagesMeta": [
      {
          "publicId": "photo-1497366216548-37526070297c?w=800",
          "url": "https://images.unsplash.com/photo-1497366216548-37526070297c?w=800",
          "uploadedAt": "2025-12-30T10:44:57.100Z",
          "order": 0,
          "_id": "6953ad290cfee37056b8d146"
      },
      {
          "publicId": "photo-1524758631624-e2822e304c36?w=800",
          "url": "https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=800",
          "uploadedAt": "2025-12-30T10:44:57.100Z",
          "order": 1,
          "_id": "6953ad290cfee37056b8d147"
      },
      {
          "publicId": "photo-1556761175-4b46a572b786?w=800",
          "url": "https://images.unsplash.com/photo-1556761175-4b46a572b786?w=800",
          "uploadedAt": "2025-12-30T10:44:57.100Z",
          "order": 2,
          "_id": "6953ad290cfee37056b8d148"
      }
  ]
}
*/

class ProviderServiceModel {
  final String id;
  final ProviderInfo providerId;
  final CategoryInfo categoryId;
  final String name;
  final String description;
  final List<String> coverImages;
  final WorkSchedule workSchedule;
  final int bufferTime;
  final double ratingsAverage;
  final int ratingsCount;
  final List<dynamic> reviews;
  final int totalOrders;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CoverImageMeta> coverImagesMeta;
  final String rateByHour;
  final bool needApproval;
  final String gender;
  final List<String> languages;

  ProviderServiceModel({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.rateByHour,
    required this.needApproval,
    required this.gender,
    required this.languages,
    required this.coverImages,
    required this.workSchedule,
    required this.bufferTime,
    required this.ratingsAverage,
    required this.ratingsCount,
    required this.totalOrders,
    required this.createdAt,
    required this.updatedAt,
    required this.coverImagesMeta,
    required this.reviews,
  });

  factory ProviderServiceModel.fromJson(Map<String, dynamic> json) {
    return ProviderServiceModel(
      id: json['_id'] ?? '',
      providerId: ProviderInfo.fromJson(json['providerId'] ?? {}),
      categoryId: CategoryInfo.fromJson(json['categoryId'] ?? {}),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      rateByHour: json['rateByHour']?.toString() ?? '0',
      needApproval: json['needApproval'] ?? false,
      gender: json['gender'] ?? '',
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      coverImages:
          (json['coverImages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      workSchedule: WorkSchedule.fromJson(json['workSchedule'] ?? {}),
      bufferTime: json['bufferTime'] ?? 0,
      ratingsAverage: (json['ratingsAverage'] ?? 0).toDouble(),
      ratingsCount: json['ratingsCount'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      coverImagesMeta:
          (json['coverImagesMeta'] as List<dynamic>?)
              ?.map((e) => CoverImageMeta.fromJson(e))
              .toList() ??
          [],
      reviews:
          (json['reviews'] as List<dynamic>?)?.map((e) => e).toList() ?? [],
    );
  }
}

class ProviderInfo {
  final String id;
  final String userName;
  final String phoneNumber;
  final String email;
  final String profilePicture;
  final String plan;

  ProviderInfo({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.profilePicture,
    required this.plan,
  });

  factory ProviderInfo.fromJson(Map<String, dynamic> json) {
    return ProviderInfo(
      id: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      plan: json['plan'] ?? '',
    );
  }
}

class CategoryInfo {
  final String id;
  final String name;

  CategoryInfo({required this.id, required this.name});

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class WorkSchedule {
  final DaySchedule monday;
  final DaySchedule tuesday;
  final DaySchedule wednesday;
  final DaySchedule thursday;
  final DaySchedule friday;
  final DaySchedule saturday;
  final DaySchedule sunday;

  WorkSchedule({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
    return WorkSchedule(
      monday: DaySchedule.fromJson(json['monday'] ?? {}),
      tuesday: DaySchedule.fromJson(json['tuesday'] ?? {}),
      wednesday: DaySchedule.fromJson(json['wednesday'] ?? {}),
      thursday: DaySchedule.fromJson(json['thursday'] ?? {}),
      friday: DaySchedule.fromJson(json['friday'] ?? {}),
      saturday: DaySchedule.fromJson(json['saturday'] ?? {}),
      sunday: DaySchedule.fromJson(json['sunday'] ?? {}),
    );
  }
}

class DaySchedule {
  final String day;
  bool isAvailable;
  String startTime;
  String endTime;
  int bufferTime; // Buffer time in minutes (break/rest time between services)

  DaySchedule({
    required this.day,
    required this.isAvailable,
    required this.startTime,
    required this.endTime,
    this.bufferTime = 15, // Default 15 minutes buffer time
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: json['day'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      bufferTime: json['bufferTime'] ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'isAvailable': isAvailable,
      'startTime': startTime,
      'endTime': endTime,
      'bufferTime': bufferTime,
    };
  }
}

class CoverImageMeta {
  final String publicId;
  final String url;
  final DateTime uploadedAt;
  final int order;
  final String id;

  CoverImageMeta({
    required this.publicId,
    required this.url,
    required this.uploadedAt,
    required this.order,
    required this.id,
  });

  factory CoverImageMeta.fromJson(Map<String, dynamic> json) {
    return CoverImageMeta(
      publicId: json['publicId'] ?? '',
      url: json['url'] ?? '',
      uploadedAt: DateTime.tryParse(json['uploadedAt'] ?? '') ?? DateTime.now(),
      order: json['order'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: _parseInt(json['page'], 1),
      limit: _parseInt(json['limit'], 20),
      total: _parseInt(json['total'], 0),
      totalPages: _parseInt(json['totalPages'], 1),
    );
  }

  /// Helper to parse int from dynamic (handles both int and String)
  static int _parseInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is num) return value.toInt();
    return defaultValue;
  }
}

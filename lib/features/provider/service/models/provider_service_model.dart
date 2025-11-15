class ProviderServiceModel {
  final String id;
  final ProviderInfo providerId;
  final CategoryInfo categoryId;
  final String name;
  final String description;
  final String rateByHour;
  final bool needApproval;
  final String gender;
  final List<String> languages;
  final List<String> coverImages;
  final WorkSchedule workSchedule;
  final double ratingsAverage;
  final int ratingsCount;
  final int totalOrders;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.ratingsAverage,
    required this.ratingsCount,
    required this.totalOrders,
    required this.createdAt,
    required this.updatedAt,
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
      ratingsAverage: (json['ratingsAverage'] ?? 0).toDouble(),
      ratingsCount: json['ratingsCount'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
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
  final bool isAvailable;
  final String startTime;
  final String endTime;

  DaySchedule({
    required this.day,
    required this.isAvailable,
    required this.startTime,
    required this.endTime,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: json['day'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
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

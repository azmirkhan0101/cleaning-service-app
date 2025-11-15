class SearchFilterResponseModel {
  final bool success;
  final String message;
  final SearchFilterData data;

  SearchFilterResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SearchFilterResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchFilterResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SearchFilterData.fromJson(json['data'] ?? {}),
    );
  }
}

class SearchFilterData {
  final List<FilteredService> services;
  final int total;
  final AppliedFilters filters;

  SearchFilterData({
    required this.services,
    required this.total,
    required this.filters,
  });

  factory SearchFilterData.fromJson(Map<String, dynamic> json) {
    return SearchFilterData(
      services:
          (json['services'] as List?)
              ?.map((item) => FilteredService.fromJson(item))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      filters: AppliedFilters.fromJson(json['filters'] ?? {}),
    );
  }
}

class FilteredService {
  final String id;
  final String serviceName;
  final String serviceImage;
  final double averageRating;
  final String providerName;
  final String providerProfilePicture;
  final String rateByHour;

  FilteredService({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
    required this.averageRating,
    required this.providerName,
    required this.providerProfilePicture,
    required this.rateByHour,
  });

  factory FilteredService.fromJson(Map<String, dynamic> json) {
    return FilteredService(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      serviceImage: json['serviceImage'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      providerName: json['providerName'] ?? '',
      providerProfilePicture: json['providerProfilePicture'] ?? '',
      rateByHour: json['rateByHour'] ?? '0',
    );
  }
}

class AppliedFilters {
  final String? search;
  final String? categoryId;
  final String? date;
  final String? time;
  final LocationFilter? location;
  final PriceRange? priceRange;
  final String? experience;
  final String? instantBooking;
  final String? gender;
  final String? language;

  AppliedFilters({
    this.search,
    this.categoryId,
    this.date,
    this.time,
    this.location,
    this.priceRange,
    this.experience,
    this.instantBooking,
    this.gender,
    this.language,
  });

  factory AppliedFilters.fromJson(Map<String, dynamic> json) {
    return AppliedFilters(
      search: json['search'],
      categoryId: json['categoryId'],
      date: json['date'],
      time: json['time'],
      location: json['location'] != null
          ? LocationFilter.fromJson(json['location'])
          : null,
      priceRange: json['priceRange'] != null
          ? PriceRange.fromJson(json['priceRange'])
          : null,
      experience: json['experience'],
      instantBooking: json['instantBooking'],
      gender: json['gender'],
      language: json['language'],
    );
  }
}

class LocationFilter {
  final String latitude;
  final String longitude;
  final String radius;

  LocationFilter({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory LocationFilter.fromJson(Map<String, dynamic> json) {
    return LocationFilter(
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      radius: json['radius'] ?? '',
    );
  }
}

class PriceRange {
  final String min;
  final String max;

  PriceRange({required this.min, required this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(min: json['min'] ?? '', max: json['max'] ?? '');
  }
}

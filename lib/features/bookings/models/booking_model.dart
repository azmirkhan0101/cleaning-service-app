class BookingsResponseModel {
  final bool success;
  final String message;
  final BookingsData data;

  BookingsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingsResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BookingsData.fromJson(json['data'] ?? {}),
    );
  }
}

class BookingsData {
  final List<BookingModel> bookings;
  final PaginationModel pagination;

  BookingsData({required this.bookings, required this.pagination});

  factory BookingsData.fromJson(Map<String, dynamic> json) {
    return BookingsData(
      bookings:
          (json['bookings'] as List<dynamic>?)
              ?.map((booking) => BookingModel.fromJson(booking))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class BookingModel {
  final String id;
  final String serviceName;
  final OwnerAddress ownerAddress;
  final String ownerPhoneNumber;
  final String description;
  final String priceByHour;
  final int serviceDuration;
  final double totalAmount;
  final String status;

  BookingModel({
    required this.id,
    required this.serviceName,
    required this.ownerAddress,
    required this.ownerPhoneNumber,
    required this.description,
    required this.priceByHour,
    required this.serviceDuration,
    required this.totalAmount,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      ownerAddress: OwnerAddress.fromJson(json['ownerAddress'] ?? {}),
      ownerPhoneNumber: json['ownerPhoneNumber'] ?? '',
      description: json['description'] ?? '',
      priceByHour: json['priceByHour']?.toString() ?? '0',
      serviceDuration: json['serviceDuration'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}

class OwnerAddress {
  final String city;
  final double latitude;
  final double longitude;

  OwnerAddress({
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory OwnerAddress.fromJson(Map<String, dynamic> json) {
    return OwnerAddress(
      city: json['city'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}

class PaginationModel {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class ProviderBookingDetailsModel {
  final String id;
  final BookingDetails booking;
  final CustomerDetails customer;

  ProviderBookingDetailsModel({
    required this.id,
    required this.booking,
    required this.customer,
  });

  factory ProviderBookingDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return ProviderBookingDetailsModel(
      id: data['id'] as String? ?? '',
      booking: BookingDetails.fromJson(
        data['booking'] as Map<String, dynamic>? ?? {},
      ),
      customer: CustomerDetails.fromJson(
        data['customer'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class BookingDetails {
  final String scheduledAt;
  final String name;
  final String oneImage;
  final BookingAddress address;
  final String phoneNumber;
  final String description;
  final double rateByHour;
  final int serviceDuration;
  final double totalAmount;
  final String status;

  BookingDetails({
    required this.scheduledAt,
    required this.name,
    required this.oneImage,
    required this.address,
    required this.phoneNumber,
    required this.description,
    required this.rateByHour,
    required this.serviceDuration,
    required this.totalAmount,
    required this.status,
  });

  // Helper function to safely parse double values
  static double _asDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper function to safely parse int values
  static int _asInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      scheduledAt: json['scheduledAt'] as String? ?? '',
      name: json['name'] as String? ?? '',
      oneImage: json['oneImage'] as String? ?? '',
      address: BookingAddress.fromJson(
        json['address'] as Map<String, dynamic>? ?? {},
      ),
      phoneNumber: json['phoneNumber'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rateByHour: _asDouble(json['rateByHour']),
      serviceDuration: _asInt(json['serviceDuration']),
      totalAmount: _asDouble(json['totalAmount']),
      status: json['status'] as String? ?? '',
    );
  }
}

class BookingAddress {
  final String city;
  final double latitude;
  final double longitude;

  BookingAddress({
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  // Helper function to safely parse double values
  static double _asDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory BookingAddress.fromJson(Map<String, dynamic> json) {
    return BookingAddress(
      city: json['city'] as String? ?? '',
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
    );
  }
}

class CustomerDetails {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String address;
  final String description;

  CustomerDetails({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.description,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

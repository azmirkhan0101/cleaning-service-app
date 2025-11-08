import 'package:cleaning_service_app/features/owner/service/models/service_details_model.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_provider_details_model.dart';

class BookingDetailsModel {
  final String id;
  final ServiceDetailsModel service;
  final ServiceProviderDetailsModel provider;

  BookingDetailsModel({
    required this.id,
    required this.service,
    required this.provider,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      id: json['id'] ?? json['_id'] ?? '',
      service: ServiceDetailsModel.fromBookingJson(json['service'] ?? {}),
      provider: ServiceProviderDetailsModel.fromBookingJson(
        json['provider'] ?? {},
      ),
    );
  }
}

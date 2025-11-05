class ServiceResponseModel {
  final List<ServiceModel> services;

  ServiceResponseModel({required this.services});

  factory ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceResponseModel(
      services: (json['data'] as List)
          .map((item) => ServiceModel.fromJson(item))
          .toList(),
    );
  }
}

class ServiceModel {
  final String id;
  final String serviceName;
  final String serviceImage;
  final double averageRatings;
  final String providerName;
  final String providerProfilePicture;
  final bool isApprovalRequired;
  final String price;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
    required this.averageRatings,
    required this.providerName,
    required this.providerProfilePicture,
    required this.isApprovalRequired,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      serviceImage: json['serviceImage'] ?? '',
      averageRatings: (json['averageRatings'] ?? 0).toDouble(),
      providerName: json['providerName'] ?? '',
      providerProfilePicture: json['providerProfilePicture'] ?? '',
      isApprovalRequired: json['isApprovalRequired'] ?? false,
      price: json['price'] ?? '0',
    );
  }
}

class ServiceCategoryModel {
  final String id;
  final String name;
  final String image;
  final int serviceCount;

  ServiceCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.serviceCount,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      serviceCount: json['serviceCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'serviceCount': serviceCount,
    };
  }
}

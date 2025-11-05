class CategoryResponseModel {
  final List<CategoryModel> categories;

  CategoryResponseModel({required this.categories});

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      categories: (json['data'] as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList(),
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final int serviceCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.serviceCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      serviceCount: json['serviceCount'] ?? 0,
    );
  }
}

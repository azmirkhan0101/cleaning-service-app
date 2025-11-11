import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_model.dart';
import 'package:get/get.dart';

// class NearbyServiceModel {
//   final String id;
//   final String serviceName;
//   final String serviceImage;
//   final double averageRatings;
//   final String providerName;
//   final String providerProfilePicture;
//   final bool isApprovalRequired;
//   final String price; // keep as string to match API
//   final double? distanceKm;

//   NearbyServiceModel({
//     required this.id,
//     required this.serviceName,
//     required this.serviceImage,
//     required this.averageRatings,
//     required this.providerName,
//     required this.providerProfilePicture,
//     required this.isApprovalRequired,
//     required this.price,
//     this.distanceKm,
//   });

//   factory NearbyServiceModel.fromJson(Map<String, dynamic> json) {
//     return NearbyServiceModel(
//       id: json['_id']?.toString() ?? '',
//       serviceName: json['serviceName']?.toString() ?? '',
//       serviceImage: json['serviceImage']?.toString() ?? '',
//       averageRatings: (json['averageRatings'] is num)
//           ? (json['averageRatings'] as num).toDouble()
//           : double.tryParse(json['averageRatings']?.toString() ?? '0') ?? 0,
//       providerName: json['providerName']?.toString() ?? '',
//       providerProfilePicture: json['providerProfilePicture']?.toString() ?? '',
//       isApprovalRequired: json['isApprovalRequired'] == true,
//       price: json['price']?.toString() ?? '0',
//       // distanceKm: (json['distanceKm'] is num)
//       //     ? (json['distanceKm'] as num).toDouble()
//       //     : double.tryParse(json['distanceKm']?.toString() ?? '0') ?? 0,
//       distanceKm: json['distanceKm'] != null
//           ? (json['distanceKm'] is num
//                 ? (json['distanceKm'] as num).toDouble()
//                 : double.tryParse(json['distanceKm'].toString()) ?? 0)
//           : null,
//     );
//   }
// }

class NearbyServicesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<ServiceModel> services = <ServiceModel>[].obs;

  int currentRadiusKm = 200;

  @override
  void onInit() {
    super.onInit();
    fetchNearby();
  }

  Future<void> fetchNearby({int? radiusKm, int limit = 50}) async {
    isLoading.value = true;
    error.value = '';
    currentRadiusKm = radiusKm ?? currentRadiusKm;

    final network = Get.find<NetworkHelper>();
    final result = await network.get<Map<String, dynamic>>(
      ApiUrl.nearbyServices(radiusKm: currentRadiusKm, limit: limit),
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (err) {
        error.value = err.message ?? 'Failed to load nearby services';
        services.clear();
        isLoading.value = false;
      },
      (data) {
        try {
          final list = (data['data']?['services'] as List<dynamic>? ?? [])
              .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList();
          services.assignAll(list);
        } catch (e) {
          error.value = 'Failed to parse services';
          services.clear();
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}

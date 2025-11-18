import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/common/models/error_response_model.dart';
import 'package:cleaning_service_app/features/provider/home/models/provider_homepage_data.dart';
import 'package:cleaning_service_app/features/provider/home/models/provider_pending_home_booking.dart';
import 'package:get/get.dart';

class ProviderHomeController extends GetxController {
  final network = Get.find<NetworkHelper>();

  final pendingBookings = <ProviderPendingHomeBooking>[].obs;
  final isLoadingPending = false.obs;
  final loadError = Rx<ErrorResponseModel?>(null);
  final homepageData = Rxn<ProviderHomepageData>();
  final isLoadingHome = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingHomeBookings();
    fetchHomepageData();
  }

  Future<void> fetchPendingHomeBookings() async {
    isLoadingPending.value = true;
    loadError.value = null;
    final result = await network.get<List<ProviderPendingHomeBooking>>(
      ApiUrl.providerPendingBookingsHomepage,
      parser: (data) {
        final list = (data['data'] as List?) ?? [];
        return list.map((e) => ProviderPendingHomeBooking.fromJson(e)).toList();
      },
    );
    result.match(
      (l) => loadError.value = l,
      (r) => pendingBookings.assignAll(r),
    );
    isLoadingPending.value = false;
  }

  Future<void> fetchHomepageData() async {
    isLoadingHome.value = true;
    final result = await network.get<ProviderHomepageData>(
      ApiUrl.providerHomepageData,
      parser: (data) =>
          ProviderHomepageData.fromJson(data as Map<String, dynamic>),
    );
    result.match((l) => loadError.value = l, (r) => homepageData.value = r);
    isLoadingHome.value = false;
  }
}

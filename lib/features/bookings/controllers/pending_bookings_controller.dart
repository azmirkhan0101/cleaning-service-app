import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/bookings/models/booking_model.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:get/get.dart';

class PendingBookingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<BookingModel> bookings = <BookingModel>[].obs;

  // Get user role
  String get userRole => AppStorageService.getUserRole() ?? 'OWNER';
  bool get isProvider => userRole.toUpperCase() == 'PROVIDER';

  String get _endpoint {
    return isProvider
        ? ApiUrl.providerPendingBookings
        : ApiUrl.ownerPendingBookings;
  }

  @override
  void onInit() {
    super.onInit();
    fetchPendingBookings();
  }

  /// Fetch pending bookings from API
  Future<void> fetchPendingBookings() async {
    try {
      isLoading.value = true;

      final response = await Get.find<NetworkHelper>()
          .request<BookingsResponseModel>(
            HttpRequestType.get.method,
            _endpoint,
            withAuth: true,
            parser: (data) => BookingsResponseModel.fromArrayJson(data),
          );

      isLoading.value = false;

      response.fold(
        (error) {
          Toast.errorToast(error.message ?? 'Failed to fetch pending bookings');
        },
        (data) {
          bookings.value = data.data.bookings;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Toast.errorToast('Failed to fetch pending bookings');
      print('Exception fetching pending bookings: $e');
    }
  }

  /// Refresh pending bookings
  Future<void> refreshBookings() async {
    await fetchPendingBookings();
  }
}

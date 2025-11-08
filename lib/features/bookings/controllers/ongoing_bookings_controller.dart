import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/bookings/models/booking_model.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:get/get.dart';

class OngoingBookingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<BookingModel> bookings = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOngoingBookings();
  }

  /// Fetch ongoing bookings from API
  Future<void> fetchOngoingBookings() async {
    try {
      isLoading.value = true;

      final response = await Get.find<NetworkHelper>()
          .request<BookingsResponseModel>(
            HttpMethod.get.method,
            ApiUrl.ongoingBookings,
            withAuth: true,
            parser: (data) => BookingsResponseModel.fromArrayJson(data),
          );

      isLoading.value = false;

      response.fold(
        (error) {
          Toast.errorToast(error.message ?? 'Failed to fetch ongoing bookings');
        },
        (data) {
          bookings.value = data.data.bookings;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Toast.errorToast('Failed to fetch ongoing bookings');
      print('Exception fetching ongoing bookings: $e');
    }
  }

  /// Refresh ongoing bookings
  Future<void> refreshBookings() async {
    await fetchOngoingBookings();
  }
}

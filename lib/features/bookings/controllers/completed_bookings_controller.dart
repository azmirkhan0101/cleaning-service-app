import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/bookings/models/booking_model.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:get/get.dart';

class CompletedBookingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<BookingModel> bookings = <BookingModel>[].obs;

  // Get user role
  String get userRole => AppStorageService.getUserRole() ?? 'OWNER';
  bool get isProvider => userRole.toUpperCase() == 'PROVIDER';

  String get _endpoint {
    return isProvider
        ? ApiUrl.providerCompletedBookings
        : ApiUrl.ownerCompletedBookings;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCompletedBookings();
  }

  /// Fetch completed bookings from API
  Future<void> fetchCompletedBookings() async {
    try {
      isLoading.value = true;

      final response = await Get.find<NetworkHelper>()
          .request<BookingsResponseModel>(
            HttpMethod.get.method,
            _endpoint,
            withAuth: true,
            parser: (data) => BookingsResponseModel.fromArrayJson(data),
          );

      isLoading.value = false;

      response.fold(
        (error) {
          Toast.errorToast(
            error.message ?? 'Failed to fetch completed bookings',
          );
        },
        (data) {
          bookings.value = data.data.bookings;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Toast.errorToast('Failed to fetch completed bookings');
      print('Exception fetching completed bookings: $e');
    }
  }

  /// Refresh completed bookings
  Future<void> refreshBookings() async {
    await fetchCompletedBookings();
  }
}

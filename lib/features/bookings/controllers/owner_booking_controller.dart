import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/bookings/models/booking_model.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:get/get.dart';

class OwnerBookingController extends GetxController {
  RxInt selectedTabIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxList<BookingModel> allBookings = <BookingModel>[].obs;
  RxList<BookingModel> filteredBookings = <BookingModel>[].obs;
  Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);

  final List<String> tabTitles = [
    "All",
    "PENDING",
    "ONGOING",
    "COMPLETED",
    "CANCELLED",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  /// Fetch bookings from API
  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;

      final response = await Get.find<NetworkHelper>()
          .request<BookingsResponseModel>(
            HttpMethod.get.method,
            ApiUrl.myBookings,
            withAuth: true,
            parser: (data) => BookingsResponseModel.fromJson(data),
          );

      isLoading.value = false;

      response.fold(
        (error) {
          Toast.errorToast(error.message ?? 'Failed to fetch bookings');
        },
        (data) {
          allBookings.value = data.data.bookings;
          pagination.value = data.data.pagination;
          filterServices(0); // Show all bookings initially
        },
      );
    } catch (e) {
      isLoading.value = false;
      Toast.errorToast('Failed to fetch bookings');
      print('Exception fetching bookings: $e');
    }
  }

  /// Refresh bookings
  Future<void> refreshBookings() async {
    await fetchBookings();
  }

  /// Filter bookings by status
  void filterServices(int index) {
    selectedTabIndex.value = index;

    if (index == 0) {
      // Show all bookings
      filteredBookings.value = allBookings;
    } else {
      // Filter by status
      final status = tabTitles[index];
      filteredBookings.value = allBookings
          .where((booking) => booking.status.toUpperCase() == status)
          .toList();
    }
  }
}

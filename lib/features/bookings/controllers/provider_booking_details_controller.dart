import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/bookings/models/provider_booking_details_model.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:get/get.dart';

class ProviderBookingDetailsController extends GetxController {
  // Use Get.find to resolve the shared NetworkHelper instance

  // Observables
  final Rx<ProviderBookingDetailsModel?> bookingDetails =
      Rx<ProviderBookingDetailsModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAccepting = false.obs;
  final RxBool isRejecting = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString bookingId = ''.obs;

  // Set booking ID and fetch details
  void setBookingId(String id) {
    bookingId.value = id;
    fetchBookingDetails();
  }

  // Fetch provider booking details
  Future<void> fetchBookingDetails() async {
    if (bookingId.value.isEmpty) {
      errorMessage.value = 'Booking ID is required';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.get.method,
            ApiUrl.bookingProviderDetails(bookingId.value),
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );

      result.fold(
        (error) {
          errorMessage.value =
              error.message ?? 'Failed to load booking details';
        },
        (response) {
          try {
            bookingDetails.value = ProviderBookingDetailsModel.fromJson(
              response,
            );
          } catch (e) {
            errorMessage.value = 'Invalid booking details format';
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh booking details
  Future<void> refreshBookingDetails() async {
    await fetchBookingDetails();
  }

  // Accept booking
  Future<bool> acceptBooking() async {
    if (bookingId.value.isEmpty) {
      errorMessage.value = 'Booking ID is required';
      return false;
    }

    try {
      isAccepting.value = true;
      errorMessage.value = '';

      final result = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.patch.method,
            ApiUrl.acceptBooking(bookingId.value),
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );

      return result.fold(
        (error) {
          errorMessage.value = error.message ?? 'Failed to accept booking';
          return false;
        },
        (response) {
          // Update local booking details if response contains updated data
          if (response['data'] != null) {
            try {
              // Refresh booking details to get updated status
              fetchBookingDetails();
            } catch (_) {
            }
          }
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return false;
    } finally {
      isAccepting.value = false;
    }
  }

  // Reject booking
  Future<bool> rejectBooking() async {
    if (bookingId.value.isEmpty) {
      errorMessage.value = 'Booking ID is required';
      return false;
    }

    try {
      isRejecting.value = true;
      errorMessage.value = '';

      final result = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.patch.method,
            ApiUrl.rejectBooking(bookingId.value),
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );

      return result.fold(
        (error) {
          errorMessage.value = error.message ?? 'Failed to reject booking';
          return false;
        },
        (response) {
          // Update local booking details if response contains updated data
          if (response['data'] != null) {
            try {
              // Refresh booking details to get updated status
              fetchBookingDetails();
            } catch (_) {
            }
          }
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return false;
    } finally {
      isRejecting.value = false;
    }
  }

  @override
  void onClose() {
    bookingDetails.value = null;
    super.onClose();
  }
}

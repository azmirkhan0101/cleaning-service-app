import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/owner/service/models/review_model.dart';
import 'package:cleaning_service_app/features/owner/service/models/schedule_model.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_details_model.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_provider_details_model.dart';
import 'package:get/get.dart';

class ServiceDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isProviderLoading = false.obs;
  RxBool isReviewsLoading = false.obs;
  RxBool isScheduleLoading = false.obs;

  RxString errorMessage = ''.obs;
  RxString serviceId = ''.obs;

  Rx<ServiceDetailsModel?> serviceDetails = Rx<ServiceDetailsModel?>(null);
  Rx<ServiceProviderDetailsModel?> providerDetails =
      Rx<ServiceProviderDetailsModel?>(null);
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  Rx<ScheduleModel?> schedule = Rx<ScheduleModel?>(null);
  RxString bookingId = ''.obs;
  RxBool isCancelling = false.obs;

  void setServiceId(String id) {
    serviceId.value = id;
    fetchServiceDetails();
  }

  void setBookingId(String id) {
    bookingId.value = id;
    fetchBookingDetails();
  }

  Future<void> fetchServiceDetails() async {
    if (serviceId.value.isEmpty) {
      Toast.errorToast('Service ID is required');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final response = await Get.find<NetworkHelper>()
        .request<ServiceDetailsModel>(
          HttpRequestType.get.method,
          ApiUrl.serviceDetails(serviceId.value),
          withAuth: true,
          parser: (data) => ServiceDetailsModel.fromJson(data['data']),
        );

    isLoading.value = false;

    response.fold(
      (error) {
        errorMessage.value = error.message ?? 'Failed to fetch service details';
        Toast.errorToast(errorMessage.value);
      },
      (data) {
        serviceDetails.value = data;
      },
    );
  }

  Future<void> fetchProviderDetails() async {
    if (serviceId.value.isEmpty) return;

    isProviderLoading.value = true;

    final response = await Get.find<NetworkHelper>()
        .request<ServiceProviderDetailsModel>(
          HttpRequestType.get.method,
          ApiUrl.serviceProviderDetails(serviceId.value),
          withAuth: true,
          parser: (data) => ServiceProviderDetailsModel.fromJson(data['data']),
        );

    isProviderLoading.value = false;

    response.fold(
      (error) {
        Toast.errorToast(error.message ?? 'Failed to fetch provider details');
      },
      (data) {
        providerDetails.value = data;
      },
    );
  }

  Future<void> fetchBookingDetails() async {
    if (bookingId.value.isEmpty) {
      Toast.errorToast('Booking ID is required');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final response = await Get.find<NetworkHelper>()
        .request<Map<String, dynamic>>(
          HttpRequestType.get.method,
          ApiUrl.bookingOwnerDetails(bookingId.value),
          withAuth: true,
          parser: (data) => data['data'] ?? {},
        );

    isLoading.value = false;

    response.fold(
      (error) {
        errorMessage.value = error.message ?? 'Failed to fetch booking details';
        Toast.errorToast(errorMessage.value);
      },
      (data) {
        try {
          final serviceJson = data['service'] ?? {};
          final providerJson = data['provider'] ?? {};

          serviceDetails.value = ServiceDetailsModel.fromBookingJson(
            serviceJson,
          );
          providerDetails.value = ServiceProviderDetailsModel.fromBookingJson(
            providerJson,
          );

          // Try to derive serviceId for reviews fetching
          final derivedServiceId = serviceJson['_id'] ?? serviceJson['id'];
          if (derivedServiceId is String && derivedServiceId.isNotEmpty) {
            serviceId.value = derivedServiceId;
          }
        } catch (e) {
          Toast.errorToast('Invalid booking details format');
        }
      },
    );
  }

  Future<void> fetchReviews() async {
    if (serviceId.value.isEmpty) return;

    isReviewsLoading.value = true;

    final response = await Get.find<NetworkHelper>().request<List<ReviewModel>>(
      HttpRequestType.get.method,
      ApiUrl.serviceRatingsReviews(serviceId.value),
      withAuth: true,
      parser: (data) => (data['data'] as List)
          .map((item) => ReviewModel.fromJson(item))
          .toList(),
    );

    isReviewsLoading.value = false;

    response.fold(
      (error) {
        Toast.errorToast(error.message ?? 'Failed to fetch reviews');
      },
      (data) {
        reviews.value = data;
      },
    );
  }

  Future<void> fetchSchedule() async {
    if (serviceId.value.isEmpty) return;

    isScheduleLoading.value = true;

    final response = await Get.find<NetworkHelper>().request<ScheduleModel>(
      HttpRequestType.get.method,
      ApiUrl.serviceProviderSchedule(serviceId.value),
      withAuth: true,
      parser: (data) => ScheduleModel.fromJson(data['data']),
    );

    isScheduleLoading.value = false;

    response.fold(
      (error) {
        Toast.errorToast(error.message ?? 'Failed to fetch schedule');
      },
      (data) {
        schedule.value = data;
      },
    );
  }

  Future<void> refreshAll() async {
    await Future.wait([
      fetchServiceDetails(),
      fetchProviderDetails(),
      fetchReviews(),
      fetchSchedule(),
    ]);
  }

  /// Cancel booking (owner action)
  Future<bool> cancelBooking() async {
    if (bookingId.value.isEmpty) {
      Toast.errorToast('Booking ID is required');
      return false;
    }

    isCancelling.value = true;
    errorMessage.value = '';

    final response = await Get.find<NetworkHelper>()
        .request<Map<String, dynamic>>(
          HttpRequestType.patch.method,
          ApiUrl.cancelBooking(bookingId.value),
          withAuth: true,
          parser: (data) => data as Map<String, dynamic>,
        );

    isCancelling.value = false;

    return response.fold(
      (error) {
        errorMessage.value = error.message ?? 'Failed to cancel booking';
        return false;
      },
      (data) {
        return true;
      },
    );
  }
}

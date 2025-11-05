import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_details_model.dart';
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

  void setServiceId(String id) {
    serviceId.value = id;
    fetchServiceDetails();
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
          HttpMethod.get.method,
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
          HttpMethod.get.method,
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

  Future<void> fetchReviews() async {
    if (serviceId.value.isEmpty) return;

    isReviewsLoading.value = true;

    final response = await Get.find<NetworkHelper>().request<List<ReviewModel>>(
      HttpMethod.get.method,
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
      HttpMethod.get.method,
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
}

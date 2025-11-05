import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_model.dart';
import 'package:get/get.dart';

class OwnerServiceListController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<ServiceModel> services = <ServiceModel>[].obs;
  RxString categoryId = ''.obs;

  void setCategoryId(String id) {
    categoryId.value = id;
    fetchServices();
  }

  Future<void> fetchServices() async {
    if (categoryId.value.isEmpty) {
      Toast.errorToast('Category ID is required');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final response = await Get.find<NetworkHelper>()
        .request<ServiceResponseModel>(
          HttpMethod.get.method,
          ApiUrl.servicesByCategory(categoryId.value),
          withAuth: true,
          parser: (data) => ServiceResponseModel.fromJson(data),
        );

    isLoading.value = false;

    response.fold(
      (error) {
        errorMessage.value = error.message ?? 'Failed to fetch services';
        Toast.errorToast(errorMessage.value);
      },
      (data) {
        services.value = data.services;
      },
    );
  }

  Future<void> refreshServices() async {
    await fetchServices();
  }
}

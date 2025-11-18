import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/provider/service/models/provider_service_model.dart';
import 'package:get/get.dart';

class ProviderServiceDetailsController extends GetxController {
  final network = Get.find<NetworkHelper>();

  // Observables
  final Rx<ProviderServiceModel?> serviceDetails = Rx<ProviderServiceModel?>(
    null,
  );
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString serviceId = ''.obs;

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

    final response = await network.request<ProviderServiceModel>(
      'GET',
      '${ApiUrl.baseUrl}/service/${serviceId.value}',
      withAuth: true,
      parser: (data) => ProviderServiceModel.fromJson(data['data']),
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

  Future<void> refreshServiceDetails() async {
    await fetchServiceDetails();
  }

  /// Delete service
  Future<bool> deleteService() async {
    if (serviceId.value.isEmpty) {
      Toast.errorToast('Service ID is required');
      return false;
    }

    final response = await network.request<Map<String, dynamic>>(
      'DELETE',
      '${ApiUrl.baseUrl}/service/${serviceId.value}',
      withAuth: true,
      parser: (data) => data as Map<String, dynamic>,
    );

    return response.fold(
      (error) {
        Toast.errorToast(error.message ?? 'Failed to delete service');
        return false;
      },
      (data) {
        Toast.successToast('Service deleted successfully');
        return true;
      },
    );
  }
}

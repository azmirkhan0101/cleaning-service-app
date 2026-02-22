import 'dart:async';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OwnerServiceListController extends GetxController {

  Timer? timer;

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<ServiceModel> services = <ServiceModel>[].obs;
  RxString categoryId = ''.obs;

  void setCategoryId(String id) {
    categoryId.value = id;
    fetchServices(refresh: true);
    autoRefreshServices();
  }

  void autoRefreshServices(){
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchServices(refresh: false);
    });
  }

  Future<void> fetchServices({bool refresh = true}) async {
    if (categoryId.value.isEmpty) {
      Toast.errorToast('Category ID is required');
      return;
    }

    if (refresh) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    final response = await Get.find<NetworkHelper>()
        .request<ServiceResponseModel>(
          HttpRequestType.get.method,
          ApiUrl.servicesByCategory(categoryId.value),
          withAuth: true,
          parser: (data) => ServiceResponseModel.fromJson(data),
        );

    if ( isLoading.value ){
      isLoading.value = false;
    }

    response.fold(
      (error) {
        if( refresh ){
          errorMessage.value = error.message ?? 'Failed to fetch services';
          Toast.errorToast(errorMessage.value);
        }
      },
      (data) {
        if( !listEquals(data.services, services.value) ){
          services.assignAll(data.services);
        }
      },
    );
  }

  Future<void> refreshServices() async {
    await fetchServices();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}

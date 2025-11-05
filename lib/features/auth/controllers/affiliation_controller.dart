import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:get/get.dart';

class AffiliationController extends GetxController {
  final isLoading = false.obs;
  final affiliationContent = ''.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAffiliationProgram();
  }

  Future<void> fetchAffiliationProgram() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await Get.find<NetworkHelper>().request(
      HttpMethod.get.method,
      ApiUrl.getAffiliationProgram,
      withAuth: false,
    );

    isLoading.value = false;

    return response.fold(
      (error) {
        errorMessage.value = error.message ?? 'An unexpected error occurred';
      },
      (data) {
        affiliationContent.value = data['data']['text'] ?? '';
      },
    );
  }
}

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/provider_service_details_controller.dart';
import 'package:get/get.dart';

class DeleteServiceImagesController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<bool> deleteImage(String serviceId, String photoId) async {
    isLoading.value = true;
    // /service/:serviceId/photos/:photoId

    final response = await Get.find<NetworkHelper>().request(
      'DELETE',
      '${ApiUrl.baseUrl}/service/$serviceId/photos/$photoId',
    );

    isLoading.value = false;

    return response.fold(
      (error) {
        errorMessage.value = error.message ?? "Something went wrong";
        Toast.errorToast(errorMessage.value);
        return false;
      },
      (success) {
        errorMessage.value = "";
        Toast.successToast("Image deleted successfully");
        Get.find<ProviderServiceDetailsController>().fetchServiceDetails(
          serviceId,
        );
        return true;
      },
    );
  }
}

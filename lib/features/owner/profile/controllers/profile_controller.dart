import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/owner/profile/models/profile_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable profile data
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fetch user profile from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkHelper>()
          .request<ProfileResponseModel>(
            HttpMethod.get.method,
            ApiUrl.profile,
            withAuth: true,
            parser: (data) => ProfileResponseModel.fromJson(data),
          );

      isLoading.value = false;

      response.fold(
        (error) {
          // Handle error
          errorMessage.value = error.message ?? 'Failed to load profile';
          print('Error fetching profile: ${error.message}');
          Get.snackbar(
            'Error',
            error.message ?? 'Failed to load profile',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (data) {
          // Parse response
          profile.value = data.data;
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load profile';
      print('Exception fetching profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await fetchProfile();
  }
}

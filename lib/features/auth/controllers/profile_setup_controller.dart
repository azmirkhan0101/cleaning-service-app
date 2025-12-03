import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:cleaning_service_app/features/auth/models/profile_setup_response_model.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:get/get.dart';

class ProfileSetupController extends SelectionController {
  RxString email = ''.obs;
  RxString errorMessage = ''.obs;
  Rx<ProfileSetupResponseModel?> profileSetupResponse =
      Rx<ProfileSetupResponseModel?>(null);

  RxBool isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure LocationController is available for location search widget
    if (!Get.isRegistered<LocationController>()) {
      Get.put(LocationController(), permanent: true);
    }
  }

  Future<bool> completeRegistrationSetup({String? plan}) async {
    isUploading.value = true;

    // Prepare fields as strings for multipart
    final Map<String, String> fields = {
      'email': email.value,
      'lattitude': latitude.value,
      'longitude': longitude.value,
      'role': selectedRole.value.value,
      'affiliationCondition': 'true',
    };

    if (selectedRole.value == Role.provider) {
      fields['experience'] = experience.value;
      // fields['experience'] = "0-2";
    }
    if (selectedRole.value == Role.owner) {
      fields['resultRange'] = resultRange.value.toString();
    }
    if (plan != null && plan.isNotEmpty) {
      fields['plan'] = plan;
    }

    final List<MultipartBody> files = [
      MultipartBody(key: "profilePicture", file: profileImage.value!),
      MultipartBody(key: "NIDFront", file: frontIdImage.value!),
      MultipartBody(key: "NIDBack", file: backIdImage.value!),
    ];

    // if (selfieWithIdImage.value != null) {
    //   files.add(
    //     MultipartBody(key: "selfieWithNID", file: selfieWithIdImage.value!),
    //   );
    // }

    try {
      final response = await Get.find<NetworkHelper>().multipart(
        url: ApiUrl.completeRegistration,
        method: "POST",
        fields: fields,
        files: files,
        withAuth: false,
        parser: (data) {
          return ProfileSetupResponseModel.fromJson(data);
        },
      );

      isUploading.value = false;

      return response.fold(
        (error) {
          // Log error and return false
          errorMessage.value = error.message ?? 'Upload failed';
          return false;
        },
        (data) {
          // success
          profileSetupResponse.value = data;
          errorMessage.value = '';
          resetState();
          return true;
        },
      );
    } catch (e) {
      isUploading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }

  /// Reset controller state
  void resetState() {
    errorMessage.value = '';
    profileSetupResponse.value = null;
    profileImage.value = null;
    frontIdImage.value = null;
    backIdImage.value = null;
    selfieWithIdImage.value = null;
    latitude.value = '';
    longitude.value = '';
    resultRange.value = 25.0;
    experience.value = '';
    currentIndex.value = 0;
  }
}

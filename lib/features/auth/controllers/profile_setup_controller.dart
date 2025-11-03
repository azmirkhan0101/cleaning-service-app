import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:cleaning_service_app/features/auth/models/profile_setup_response_model.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:get/get.dart';

class ProfileSetupController extends SelectionController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rx<ProfileSetupResponseModel?> profileSetupResponse =
      Rx<ProfileSetupResponseModel?>(null);

  /// Complete registration for both Owner and Provider
  Future<bool> completeRegistration() async {
    // Validate required fields
    if (!_validateFields()) {
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Prepare multipart files based on role
      final List<MultipartBody> files = [];

      // Add profile picture if available
      if (profileImage.value != null) {
        files.add(
          MultipartBody(key: 'profilePicture', file: profileImage.value!),
        );
      }

      // Add provider-specific documents
      if (selectedRole.value == Role.provider) {
        if (frontIdImage.value != null) {
          files.add(MultipartBody(key: 'NIDFront', file: frontIdImage.value!));
        }

        if (backIdImage.value != null) {
          files.add(MultipartBody(key: 'NIDBack', file: backIdImage.value!));
        }

        if (selfieWithIdImage.value != null) {
          files.add(
            MultipartBody(key: 'selfieWithNID', file: selfieWithIdImage.value!),
          );
        }
      }

      // Prepare form fields
      final Map<String, String> fields = _prepareFormFields();

      // Make API call
      final response = await Get.find<NetworkHelper>()
          .multipart<ProfileSetupResponseModel>(
            url: ApiUrl.completeRegistration,
            method: 'POST',
            fields: fields,
            files: files,
            withAuth: true,
            parser: (data) {
              return ProfileSetupResponseModel.fromJson(data['data']);
            },
          );

      isLoading.value = false;

      // Handle response
      return response.fold(
        // Error case
        (error) {
          errorMessage.value = error.message ?? 'Registration failed';
          Toast.errorToast(errorMessage.value);
          return false;
        },
        // Success case
        (data) async {
          profileSetupResponse.value = data;

          // Save user data to storage
          await AppStorageService.saveUserId(data.id);
          await AppStorageService.saveUserName(data.userName);
          await AppStorageService.saveUserEmail(data.email);

          Toast.successToast('Registration completed successfully!');
          return true;
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An unexpected error occurred: ${e.toString()}';
      Toast.errorToast(errorMessage.value);
      return false;
    }
  }

  /// Validate required fields based on role
  bool _validateFields() {
    if (latitude.value.isEmpty || longitude.value.isEmpty) {
      errorMessage.value = 'Please set your location';
      Toast.errorToast(errorMessage.value);
      return false;
    }

    if (selectedRole.value == Role.provider) {
      // Provider specific validations
      if (experience.value.isEmpty) {
        errorMessage.value = 'Please select your experience level';
        Toast.errorToast(errorMessage.value);
        return false;
      }

      if (frontIdImage.value == null ||
          backIdImage.value == null ||
          selfieWithIdImage.value == null) {
        errorMessage.value = 'Please upload all required documents';
        Toast.errorToast(errorMessage.value);
        return false;
      }
    }

    return true;
  }

  /// Prepare form fields for API request
  Map<String, String> _prepareFormFields() {
    final Map<String, String> fields = {
      'lattitude': latitude.value,
      'longitude': longitude.value,
      'resultRange': resultRange.value.toString(),
      'plan': _getPlanString(),
      'role': selectedRole.value == Role.owner ? 'OWNER' : 'PROVIDER',
      'affiliationCondition': 'true',
    };

    // Add provider-specific fields
    if (selectedRole.value == Role.provider) {
      fields['experience'] = experience.value;
    }

    return fields;
  }

  /// Convert plan index to plan string
  String _getPlanString() {
    switch (typPaymentStatues.value) {
      case 0:
        return 'BASIC';
      case 1:
        return 'SILVER';
      case 2:
        return 'GOLD';
      case 3:
        return 'PLATINUM';
      default:
        return 'BASIC';
    }
  }

  /// Reset controller state
  void resetState() {
    isLoading.value = false;
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
    typPaymentStatues.value = 0;
    currentIndex.value = 0;
  }
}

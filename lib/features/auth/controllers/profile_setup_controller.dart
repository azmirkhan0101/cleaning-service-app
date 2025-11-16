import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:cleaning_service_app/features/auth/models/profile_setup_response_model.dart';
import 'package:cleaning_service_app/features/provider/subscription/models/subscription_plan_model.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:get/get.dart';

class ProfileSetupController extends SelectionController {
  RxString email = ''.obs;
  RxString errorMessage = ''.obs;
  Rx<ProfileSetupResponseModel?> profileSetupResponse =
      Rx<ProfileSetupResponseModel?>(null);

  RxBool isUploading = false.obs;
  RxBool isLoadingPlans = false.obs;
  RxList<SubscriptionPlanModel> subscriptionPlans =
      <SubscriptionPlanModel>[].obs;

  RxBool isYearlyPlan = false.obs;
  void togglePlanType() {
    isYearlyPlan.value = !isYearlyPlan.value;
  }

  /// Calculate yearly price with 20% discount
  /// Returns the discounted yearly price (monthly price * 12 * 0.8)
  double calculateYearlyPrice(int monthlyPrice) {
    if (monthlyPrice == 0) return 0;
    return (monthlyPrice * 12 * 0.8);
  }

  /// Format price display based on billing period
  String formatPrice(int monthlyPrice, bool isYearly) {
    if (monthlyPrice == 0) return 'Free';
    if (isYearly) {
      final yearlyPrice = calculateYearlyPrice(monthlyPrice);
      return '€${yearlyPrice.toStringAsFixed(0)} / year';
    }
    return '€$monthlyPrice / month';
  }

  /// Fetch subscription plans from API
  Future<void> fetchSubscriptionPlans() async {
    try {
      isLoadingPlans.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkHelper>()
          .get<SubscriptionPlansResponse>(
            ApiUrl.subscriptionPlans,
            parser: (data) => SubscriptionPlansResponse.fromJson(data),
          );

      response.fold(
        (error) {
          errorMessage.value = error.message ?? 'Failed to load plans';
          print('Error fetching plans: ${error.message}');
        },
        (data) {
          subscriptionPlans.value = data.data;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load subscription plans';
      print('Exception fetching plans: $e');
    } finally {
      isLoadingPlans.value = false;
    }
  }

  Future<bool> completeRegistrationSetup() async {
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
    if (typPaymentStatues.value < 10) {
      fields['plan'] = _getPlanString();
      // fields['plan'] = "BASIC";
    }

    final List<MultipartBody> files = [
      MultipartBody(key: "NIDFront", file: frontIdImage.value!),
      MultipartBody(key: "NIDBack", file: backIdImage.value!),
    ];

    if (selfieWithIdImage.value != null) {
      files.add(
        MultipartBody(key: "selfieWithNID", file: selfieWithIdImage.value!),
      );
    }

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
          // Log/show error and return false
          Get.snackbar(
            'Error',
            error.message ?? 'Upload failed',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        },
        (data) {
          // success
          profileSetupResponse.value = data;
          Get.snackbar(
            'Success',
            'Profile setup completed successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
          resetState();
          return true;
        },
      );
    } catch (e) {
      isUploading.value = false;
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  /// Convert plan index to plan string
  String _getPlanString() {
    switch (typPaymentStatues.value) {
      case 0:
        return 'FREE';
      case 1:
        return 'SILVER';
      case 2:
        return 'GOLD';
      case 3:
        return 'PLATINUM';
      default:
        return 'FREE';
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
    typPaymentStatues.value = 0;
    currentIndex.value = 0;
  }
}

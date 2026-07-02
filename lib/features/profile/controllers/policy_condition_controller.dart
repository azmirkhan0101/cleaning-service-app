import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/profile/models/policy_condition_model.dart';
import 'package:get/get.dart';

class PolicyConditionController extends GetxController {
  final NetworkHelper _networkHelper = Get.find<NetworkHelper>();

  Rx<PolicyConditionModel?> aboutUs = Rx<PolicyConditionModel?>(null);
  Rx<PolicyConditionModel?> termsAndConditions = Rx<PolicyConditionModel?>(
    null,
  );
  Rx<PolicyConditionModel?> privacyPolicy = Rx<PolicyConditionModel?>(null);
  Rx<PolicyConditionModel?> affiliationProgram = Rx<PolicyConditionModel?>(
    null,
  );

  // Loading states
  RxBool isLoadingAboutUs = false.obs;
  RxBool isLoadingTerms = false.obs;
  RxBool isLoadingPrivacy = false.obs;
  RxBool isLoadingAffiliation = false.obs;

  // Error messages
  RxString errorAboutUs = ''.obs;
  RxString errorTerms = ''.obs;
  RxString errorPrivacy = ''.obs;
  RxString errorAffiliation = ''.obs;

  /// Fetch About Us content
  Future<void> fetchAboutUs() async {
    isLoadingAboutUs.value = true;
    errorAboutUs.value = '';

    final result = await _networkHelper.get<Map<String, dynamic>>(
      ApiUrl.getAboutUs,
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (error) {
        errorAboutUs.value = error.message ?? 'Failed to load About Us';
        isLoadingAboutUs.value = false;
      },
      (data) {
        try {
          aboutUs.value = PolicyConditionModel.fromJson(data['data']);
        } catch (e) {
          errorAboutUs.value = 'Failed to parse About Us content';
        } finally {
          isLoadingAboutUs.value = false;
        }
      },
    );
  }

  /// Fetch Privacy Policy content
  Future<void> fetchPrivacyPolicy() async {
    isLoadingPrivacy.value = true;
    errorPrivacy.value = '';

    final result = await _networkHelper.get<Map<String, dynamic>>(
      ApiUrl.getPrivacyPolicy,
      parser: (data) => data as Map<String, dynamic>,
    );

    // http.Response response = await http.get(Uri.parse(ApiUrl.getPrivacyPolicy));
    // print("Privacy Policy Status code: ${response.statusCode}");
    // print("Privacy Policy Response: ${response.body}");

    result.fold(
      (error) {
        errorPrivacy.value = error.message ?? 'Failed to load Privacy Policy';
        isLoadingPrivacy.value = false;
      },
      (data) {
        try {
          privacyPolicy.value = PolicyConditionModel.fromJson(data['data']);
        } catch (e) {
          errorPrivacy.value = 'Failed to parse Privacy Policy content';
        } finally {
          isLoadingPrivacy.value = false;
        }
      },
    );
  }

  /// Fetch Terms and Conditions content
  Future<void> fetchTermsAndConditions() async {
    isLoadingTerms.value = true;
    errorTerms.value = '';

    final result = await _networkHelper.get<Map<String, dynamic>>(
      ApiUrl.getTermsAndConditions,
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (error) {
        errorTerms.value =
            error.message ?? 'Failed to load Terms and Conditions';
        isLoadingTerms.value = false;
      },
      (data) {
        try {
          termsAndConditions.value = PolicyConditionModel.fromJson(
            data['data'],
          );
        } catch (e) {
          errorTerms.value = 'Failed to parse Terms and Conditions content';
        } finally {
          isLoadingTerms.value = false;
        }
      },
    );
  }

  /// Fetch Affiliation Program content
  Future<void> fetchAffiliationProgram() async {
    isLoadingAffiliation.value = true;
    errorAffiliation.value = '';

    final result = await _networkHelper.get<Map<String, dynamic>>(
      ApiUrl.getAffiliationProgram,
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (error) {
        errorAffiliation.value =
            error.message ?? 'Failed to load Affiliation Program';
        isLoadingAffiliation.value = false;
      },
      (data) {
        try {
          affiliationProgram.value = PolicyConditionModel.fromJson(
            data['data'],
          );
        } catch (e) {
          errorAffiliation.value =
              'Failed to parse Affiliation Program content';
        } finally {
          isLoadingAffiliation.value = false;
        }
      },
    );
  }

  /// Retry fetch for specific content type
  void retry(String contentType) {
    switch (contentType) {
      case 'aboutUs':
        fetchAboutUs();
        break;
      case 'privacyPolicy':
        fetchPrivacyPolicy();
        break;
      case 'termsAndConditions':
        fetchTermsAndConditions();
        break;
      case 'affiliationProgram':
        fetchAffiliationProgram();
        break;
    }
  }
}

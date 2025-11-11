import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/profile/models/referral_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReferralController extends GetxController {
  final NetworkHelper _networkHelper = Get.find<NetworkHelper>();

  Rx<ReferralModel?> referralInfo = Rx<ReferralModel?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferralInfo();
  }

  /// Fetch referral information
  Future<void> fetchReferralInfo() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _networkHelper.get<Map<String, dynamic>>(
      ApiUrl.getReferralInfo,
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (error) {
        errorMessage.value =
            error.message ?? 'Failed to load referral information';
        isLoading.value = false;
      },
      (data) {
        try {
          referralInfo.value = ReferralModel.fromJson(data['data']);
        } catch (e) {
          errorMessage.value = 'Failed to parse referral information';
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  /// Copy referral code to clipboard
  Future<void> copyReferralCode() async {
    if (referralInfo.value?.myReferralCode != null) {
      await Clipboard.setData(
        ClipboardData(text: referralInfo.value!.myReferralCode),
      );
      Get.snackbar(
        'Success',
        'Referral code copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  /// Share referral message using native share dialog
  Future<void> shareReferralCode() async {
    if (referralInfo.value?.shareMessage != null) {
      try {
        final result = await Share.share(
          referralInfo.value!.shareMessage,
          subject: 'Join Cleaning Service',
        );

        // Optional: Handle share result
        if (result.status == ShareResultStatus.success) {
          Get.snackbar(
            'Shared',
            'Referral code shared successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to share referral code',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    }
  }

  /// Retry fetching referral info
  void retry() {
    fetchReferralInfo();
  }
}

import 'dart:async';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerifyController extends GetxController {
  TextEditingController otpController = TextEditingController();

  final isVerifying = false.obs;
  final verificationErrorMessage = ''.obs;
  final countdown = 0.obs;
  final isResending = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Recreate the controller if it was disposed
    otpController = TextEditingController();
  }

  @override
  void onClose() {
    _timer?.cancel();
    // Only dispose if not already disposed
    try {
      otpController.dispose();
    } catch (e) {
      // Controller already disposed, ignore
    }
    super.onClose();
  }

  void startCountdown() {
    countdown.value = 20;
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<bool> verifyOtp(String email, bool forgotPassword) async {
    isVerifying.value = true;

    String url = forgotPassword
        ? ApiUrl.verifyForgotPasswordOtp
        : ApiUrl.verifyOtp;

    final Map<String, dynamic> body = {
      "email": email,
      "otp": otpController.text.trim(),
    };
    if (!forgotPassword) {
      body["otpType"] = "VERIFY_EMAIL";
    }

    final response = await Get.find<NetworkHelper>().request(
      "POST",
      url,
      body: body,
    );

    isVerifying.value = false;
    refresh();

    return response.fold(
      (error) {
        verificationErrorMessage.value =
            error.message ?? 'An unexpected error occurred';
        Toast.errorToast(verificationErrorMessage.value);
        return false;
      },
      (data) {
        Toast.successToast('OTP verified successfully');
        return true;
      },
    );
  }

  Future<bool> resendOtp(String email, String otpType) async {
    if (countdown.value > 0) return false;
    isResending.value = true;

    final response = await Get.find<NetworkHelper>().request(
      "POST",
      ApiUrl.resendOtp,
      body: {"email": email, "otpType": otpType},
    );

    isResending.value = false;

    return response.fold(
      (error) {
        Toast.errorToast(error.message ?? 'An unexpected error occurred');
        return false;
      },
      (data) {
        print(data.toString());
        Toast.successToast('OTP resent successfully');
        startCountdown();
        return true;
      },
    );
  }
}

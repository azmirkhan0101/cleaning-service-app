import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final isResetting = false.obs;
  final resetErrorMessage = ''.obs;

  Future<bool> submitResetPassword({
    required String email,
    required String otp,
  }) async {
    isResetting.value = true;

    final response = await Get.find<NetworkHelper>().post(
      ApiUrl.resetPassword,
      body: {
        "email": email,
        "otp": otp,
        "newPassword": passwordController.text.trim(),
        "confirmPassword": confirmPasswordController.text.trim(),
      },
      withAuth: false,
      // parser: (data) {
      //   return LoginResponseModel.fromJson(data["data"]);
      // },
    );

    isResetting.value = false;

    // Handle response
    return response.fold(
      // Error case
      (error) {
        resetErrorMessage.value = error.message ?? 'Reset password failed';
        Toast.errorToast(resetErrorMessage.value);
        return false;
      },
      // Success case
      (data) async {
        String message = data['message'] ?? 'Password reset successful.';
        Toast.successToast(message);
        return true;
      },
    );
  }
}

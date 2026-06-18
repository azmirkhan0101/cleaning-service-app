import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  final isSubmitting = false.obs;
  final submissionErrorMessage = ''.obs;

  Future<bool> submitForgotPassword() async {
    isSubmitting.value = true;

    final response = await Get.find<NetworkHelper>().post(
      ApiUrl.forgotPassword,
      body: {"email": emailController.text.trim()},
      withAuth: false,
    );

    isSubmitting.value = false;

    // Handle response
    return response.fold(
      // Error case
      (error) {
        submissionErrorMessage.value = error.message ?? 'Submission failed';
        Toast.errorToast(submissionErrorMessage.value);
        return false;
      },
      // Success case
      (data) async {
        print(data.toString());
        String message =
            data['message'] ??
            'Six digit code sent to your email. verify to reset password.';
        Toast.successToast(message);
        return true;
      },
    );
  }
}

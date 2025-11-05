import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/auth/models/login_response_model.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Create a unique key for each controller instance
  final loginFormKey = GlobalKey<FormState>();

  final TextEditingController loginEmailController = TextEditingController(
    text: kDebugMode ? "owner1@example.com" : null,
  );

  final TextEditingController loginPasswordController = TextEditingController(
    text: kDebugMode ? "12345678" : null,
  );

  final isRememberMe = false.obs;

  final isLoggingIn = false.obs;
  final loginErrorMessage = ''.obs;

  Rx<LoginResponseModel?> loginResponse = Rx<LoginResponseModel?>(null);

  // Control when to show validation errors
  var autovalidateMode = AutovalidateMode.disabled.obs;

  Future<bool> login() async {
    // Enable validation mode when user tries to submit, only if not already enabled
    if (autovalidateMode.value != AutovalidateMode.onUserInteraction) {
      autovalidateMode.value = AutovalidateMode.onUserInteraction;
    }

    if (!loginFormKey.currentState!.validate()) {
      return false;
    }
    isLoggingIn.value = true;

    final Map<String, String> loginData = {
      "email": loginEmailController.text.trim(),
      "password": loginPasswordController.text.trim(),
    };

    final response = await Get.find<NetworkHelper>().request(
      HttpMethod.post.method,
      ApiUrl.login,
      body: loginData,
      withAuth: false,
      parser: (data) {
        return LoginResponseModel.fromJson(data["data"]);
      },
    );

    isLoggingIn.value = false;

    // Handle response
    return response.fold(
      // Error case
      (error) {
        loginErrorMessage.value = error.message ?? 'Login failed';
        Toast.errorToast(loginErrorMessage.value);
        return false;
      },
      // Success case
      (data) async {
        loginResponse.value = data;
        // Save token and user data
        if (isRememberMe.value) {
          await AppStorageService.saveAuthToken(data.token);
        }
        await AppStorageService.saveUserId(data.userData.id);
        await AppStorageService.saveUserName(data.userData.userName);
        await AppStorageService.saveUserEmail(data.userData.email);
        Toast.successToast('Login successful! Welcome back.');
        return true;
      },
    );
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.onClose(); // ✅ This is safe and correct
  }
}

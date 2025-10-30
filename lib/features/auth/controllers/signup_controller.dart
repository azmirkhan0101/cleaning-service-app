import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/auth/models/signup_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // Create a unique key for each controller instance
  final signupFormKey = GlobalKey<FormState>();

  final TextEditingController signupNameController = TextEditingController(
    text: kDebugMode ? "John Doe" : null,
  );

  final TextEditingController signupPhoneController = TextEditingController(
    text: kDebugMode ? "1234567890" : null,
  );

  final TextEditingController signupEmailController = TextEditingController(
    text: kDebugMode ? "test@example.com" : null,
  );

  final TextEditingController signupPasswordController = TextEditingController(
    text: kDebugMode ? "12345678" : null,
  );

  final TextEditingController signupConfirmPasswordController =
      TextEditingController(text: kDebugMode ? "12345678" : null);

  final TextEditingController signupReferralController =
      TextEditingController();

  RxBool agreeWithTerms = false.obs;

  final isSigningUp = false.obs;
  final signupErrorMessage = ''.obs;

  final signupResponse = Rxn<SignupResponseModel>();

  // Control when to show validation errors
  var autovalidateMode = AutovalidateMode.disabled.obs;

  Future<bool> signUp() async {
    // Enable validation mode when user tries to submit
    autovalidateMode.value = AutovalidateMode.onUserInteraction;

    if (!signupFormKey.currentState!.validate()) {
      return false;
    }

    isSigningUp.value = true;

    final Map<String, dynamic> signupData = {
      "userName": signupNameController.text.trim(),
      "email": signupEmailController.text.trim(),
      "phoneNumber": signupPhoneController.text.trim(),
      "password": signupPasswordController.text.trim(),
      "confirmPassword": signupConfirmPasswordController.text.trim(),
    };

    // Add referral code only if provided
    final referralCode = signupReferralController.text.trim();
    if (referralCode.isNotEmpty) {
      signupData["referralCode"] = referralCode;
    }

    final response = await Get.find<NetworkHelper>().post(
      ApiUrl.signup,
      body: signupData,
      withAuth: false,
      parser: (data) {
        return SignupResponseModel.fromJson(data['data']);
      },
    );

    isSigningUp.value = false;

    // Handle response
    return response.fold(
      // Error case
      (error) {
        signupErrorMessage.value = error.message ?? 'Signup failed';
        Toast.errorToast(signupErrorMessage.value);
        return false;
      },
      // Success case
      (data) {
        signupResponse.value = data;
        Toast.successToast('Registration successful! Please verify your OTP.');

        // Log OTP in debug mode
        if (kDebugMode) {
          debugPrint("===== SIGNUP SUCCESS =====");
          debugPrint("User ID: ${data.user.id}");
          debugPrint("Email: ${data.user.email}");
          debugPrint("OTP: ${data.otp}");
          debugPrint("==========================");
        }

        return true;
      },
    );
  }

  @override
  void onClose() {
    signupNameController.dispose();
    signupPhoneController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    signupReferralController.dispose();
    super.onClose();
  }
}

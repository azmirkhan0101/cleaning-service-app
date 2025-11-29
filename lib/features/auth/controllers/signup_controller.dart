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

  final TextEditingController signupNameController = TextEditingController();

  final TextEditingController signupPhoneController = TextEditingController();

  final TextEditingController signupEmailController = TextEditingController();

  final TextEditingController signupPasswordController =
      TextEditingController();

  final TextEditingController signupConfirmPasswordController =
      TextEditingController();

  final TextEditingController signupReferralController =
      TextEditingController();

  RxBool agreeWithTerms = false.obs;

  String isoCode = Get.deviceLocale?.countryCode ?? 'IT';

  /// Stores complete E.164 number like +15551234567
  final RxString signupE164Phone = ''.obs;
  final isSigningUp = false.obs;
  final signupErrorMessage = ''.obs;

  final signupResponse = Rxn<SignupResponseModel>();

  // Flag to indicate if user should go to selection screen (OTP already verified)
  final shouldGoToSelection = false.obs;

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
      "phoneNumber": signupE164Phone.value,
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

        // Check if registration is already in progress
        // In this case, allow user to proceed to selection screen (OTP already verified)
        if (signupErrorMessage.value.toLowerCase().contains(
              'registration is already in progress',
            ) ||
            signupErrorMessage.value.toLowerCase().contains(
              'verify your otp',
            )) {
          Toast.successToast(signupErrorMessage.value);
          // Store email for selection screen
          signupResponse.value = SignupResponseModel(
            email: signupEmailController.text.trim(),
            userName: signupNameController.text.trim(),
            otp: '', // OTP was already verified
          );
          shouldGoToSelection.value =
              true; // Navigate to selection screen instead of OTP
          return true;
        }

        // For other errors, show error and block navigation
        shouldGoToSelection.value = false;
        Toast.errorToast(signupErrorMessage.value);
        return false;
      },
      // Success case
      (data) {
        signupResponse.value = data;
        shouldGoToSelection.value = false; // Normal flow: go to OTP screen
        Toast.successToast('Registration successful! Please verify your OTP.');

        // Log OTP in debug mode
        if (kDebugMode) {
          debugPrint("===== SIGNUP SUCCESS =====");
          debugPrint("Email: ${data.email}");
          debugPrint("User Name: ${data.userName}");
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

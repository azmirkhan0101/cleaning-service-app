import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/auth/models/signup_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin SignupMixin on GetxController {
  final _network = Get.find<NetworkHelper>();
  Rx<TextEditingController> signupNameController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> signupPhoneController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> signupEmailController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> signupPasswordController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> signupConfirmPasswordController =
      TextEditingController(text: kDebugMode ? "" : "").obs;

  Rx<TextEditingController> signupReferralController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  var isSigningUp = false.obs;
  var signupErrorMessage = ''.obs;
  var isSignupSuccess = false.obs;
  Rx<SignupResponseModel?> signupResponse = Rx<SignupResponseModel?>(null);

  // --> Validate Signup Form <--
  String? _validateSignupForm() {
    final name = signupNameController.value.text.trim();
    final phone = signupPhoneController.value.text.trim();
    final email = signupEmailController.value.text.trim();
    final password = signupPasswordController.value.text.trim();
    final confirmPassword = signupConfirmPasswordController.value.text.trim();

    // Name validation
    if (name.isEmpty) {
      return "Please enter your name";
    }
    if (name.length < 2) {
      return "Name must be at least 2 characters";
    }

    // Phone validation
    if (phone.isEmpty) {
      return "Please enter your phone number";
    }
    if (phone.length < 10) {
      return "Please enter a valid phone number";
    }

    // Email validation
    if (email.isEmpty) {
      return "Please enter your email";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email address";
    }

    // Password validation
    if (password.isEmpty) {
      return "Please enter your password";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      return "Please confirm your password";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    return null; // No validation errors
  }

  // --> Signup <--
  Future<bool> signUp() async {
    try {
      // Clear previous error
      signupErrorMessage.value = '';

      // Validate form
      final validationError = _validateSignupForm();
      if (validationError != null) {
        signupErrorMessage.value = validationError;
        Get.snackbar(
          'Validation Error',
          validationError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return false;
      }

      // Set loading state
      isSigningUp.value = true;
      isSignupSuccess.value = false;

      // Prepare signup data
      final Map<String, dynamic> signupData = {
        "userName": signupNameController.value.text.trim(),
        "email": signupEmailController.value.text.trim(),
        "phoneNumber": signupPhoneController.value.text.trim(),
        "password": signupPasswordController.value.text.trim(),
        "confirmPassword": signupConfirmPasswordController.value.text.trim(),
      };

      // Add referral code only if provided
      final referralCode = signupReferralController.value.text.trim();
      if (referralCode.isNotEmpty) {
        signupData["referralCode"] = referralCode;
      }

      // Make API request
      final response = await _network.post(
        ApiUrl.signup,
        body: signupData,
        parser: (data) {
          return SignupResponseModel.fromJson(data['data']);
        },
      );

      // Handle response
      return response.fold(
        // Error case
        (error) {
          isSigningUp.value = false;
          isSignupSuccess.value = false;
          signupErrorMessage.value = error.message ?? 'Signup failed';

          Get.snackbar(
            'Signup Failed',
            error.message ?? 'Something went wrong. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          return false;
        },
        // Success case
        (data) {
          isSigningUp.value = false;
          isSignupSuccess.value = true;
          signupResponse.value = data;
          signupErrorMessage.value = '';

          Get.snackbar(
            'Success',
            'Registration successful! Please verify your email with the OTP.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // Log OTP in debug mode (remove in production)
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
    } catch (e, stackTrace) {
      isSigningUp.value = false;
      isSignupSuccess.value = false;
      signupErrorMessage.value = 'An unexpected error occurred';

      debugPrint("Signup error: $e");
      debugPrint("Stack trace: $stackTrace");

      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      return false;
    }
  }

  // --> Clear Signup Form <--
  void clearSignupForm() {
    signupNameController.value.clear();
    signupPhoneController.value.clear();
    signupEmailController.value.clear();
    signupPasswordController.value.clear();
    signupConfirmPasswordController.value.clear();
    signupReferralController.value.clear();
    signupErrorMessage.value = '';
    isSignupSuccess.value = false;
    signupResponse.value = null;
  }

  // --> Dispose Controllers <--
  @override
  void onClose() {
    signupNameController.value.dispose();
    signupPhoneController.value.dispose();
    signupEmailController.value.dispose();
    signupPasswordController.value.dispose();
    signupConfirmPasswordController.value.dispose();
    signupReferralController.value.dispose();
    super.onClose();
  }
}

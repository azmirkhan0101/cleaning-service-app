import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/signup_controller.dart';
import 'package:cleaning_service_app/features/auth/screens/otp_verify_screen.dart';
import 'package:cleaning_service_app/features/common/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  String? get tag => 'signup_${identityHashCode(this)}';

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not exists with unique tag
    if (!Get.isRegistered<SignupController>(tag: tag)) {
      Get.put(SignupController(), tag: tag);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // child: Obx(() {
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 44.h),

                _buildHeader(),

                SizedBox(height: 56.h),

                _buildSignupForm(),

                SizedBox(height: 16.h),

                _buildTermsAndConditions(),

                SizedBox(height: 16.h),

                _buildSignupButton(context),

                SizedBox(height: 16.h),

                _buildOrDivider(),

                SizedBox(height: 12.h),

                _buildSocialButtons(),

                SizedBox(height: 16.h),

                _buildLoginNavigateLink(),

                SizedBox(height: 8.h),
              ],
            ),
            // }),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: 'Create Account',
              color: const Color(0xFF0F0B18),
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.40,
              letterSpacing: -0.50,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Assets.icons.user.svg(),
            ),
          ],
        ),
        CustomText(
          text: 'Welcome back',
          color: const Color(0xFF4F4F59),
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: controller.signupFormKey,
      autovalidateMode: controller.autovalidateMode.value,
      child: Column(
        children: [
          ///--> Name Field <--///
          CustomFormField(
            controller: controller.signupNameController,
            hintText: AppStrings.enterYourName,
            labelText: AppStrings.yourFirstName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 12),

          ///--> Phone Field <--///
          CustomFormField(
            controller: controller.signupPhoneController,
            hintText: AppStrings.enterYourPhone,
            labelText: AppStrings.phoneNumber,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12),

          ///--> Email Field <--///
          CustomFormField(
            controller: controller.signupEmailController,
            hintText: AppStrings.enterYourEmail,
            labelText: AppStrings.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 12),

          ///--> Password Field <--///
          CustomFormField(
            controller: controller.signupPasswordController,
            hintText: AppStrings.enterYourPassword,
            labelText: AppStrings.password,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
          ),
          SizedBox(height: 12),

          ///--> Confirm Password Field <--///
          CustomFormField(
            controller: controller.signupConfirmPasswordController,
            hintText: AppStrings.enterYourPassword,
            labelText: AppStrings.comfirmpassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != controller.signupPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
          ),
          SizedBox(height: 12),

          ///--> Referral Code Field (Optional) <--///
          CustomFormField(
            controller: controller.signupReferralController,
            hintText: AppStrings.enterReferralCode,
            labelText: AppStrings.referralCode,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return GestureDetector(
      onTap: () {
        controller.agreeWithTerms.value = !controller.agreeWithTerms.value;
      },
      child: Row(
        spacing: 8,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: controller.agreeWithTerms.value
                    ? AppColors.grey001
                    : AppColors.lightBlue,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Obx(
                () => controller.agreeWithTerms.value
                    ? Icon(Icons.check, size: 18.w, color: AppColors.green)
                    : SizedBox.shrink(),
              ),
            ),
          ),
          Expanded(
            child: CustomText(
              text: 'I agree with terms of conditions and privacy policy',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed: () => Get.to(() => const OtpVerifyScreen()),
        // onPressed: controller.isSigningUp.value
        //     ? null
        //     : () => _onPressedSignup(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appColors,
          disabledBackgroundColor: AppColors.appColors.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
        ),
        child: controller.isSigningUp.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomText2(
                    text: 'Creating Account...',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              )
            : CustomText2(
                text: AppStrings.signUp,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      spacing: 8,
      children: [
        Expanded(child: Divider(thickness: 1, color: const Color(0xFF0F0B18))),
        CustomText(
          text: 'or continue with',
          color: const Color(0xFF0F0B18),
          fontSize: 14,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
        Expanded(child: Divider(thickness: 1, color: const Color(0xFF0F0B18))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Assets.icons.googleLogo.svg(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginNavigateLink() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.loginScreen);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText2(
            text: "Have any account? ",
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(width: 6),
          CustomText2(
            text: "Sign In",
            fontWeight: FontWeight.w600,
            color: AppColors.lightBlue,
            fontSize: 14,
          ),
        ],
      ),
    );
  }

  Future<void> _onPressedSignup() async {
    try {
      // Dismiss keyboard
      FocusScope.of(Get.context!).unfocus();

      // Check terms and conditions checkbox
      if (!controller.agreeWithTerms.value) {
        Get.snackbar(
          'Terms & Conditions',
          'Please accept the terms of conditions and privacy policy',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Call signup function
      final success = await controller.signUp();

      // Navigate to OTP screen if successful
      if (success) {
        Get.to(
          () => OtpVerifyScreen(
            email: controller.signupEmailController.text.trim(),
          ),
        );
      }
    } catch (e) {
      // Handle any errors that occur during signup
      debugPrint('Signup error: $e');
      Get.snackbar(
        'Signup Failed',
        'An error occurred during signup. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/forgot_password_controller.dart';
import 'package:cleaning_service_app/features/auth/screens/otp_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/context_extension/context_extension.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  String? email;

  final ForgotPasswordController forgotPasswordController = Get.put(
    ForgotPasswordController(),
  );

  // final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      appBar: CustomAppBar(backButton: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText2(
                  text: 'Forgot Password',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),

                SizedBox(height: 8),

                CustomText2(
                  text: 'Welcome back',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText2(
                      top: 150.h,
                      text: "Email Confirmation",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),

                    CustomText2(
                      text: "Enter Your email for verification.",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      maxLines: 2,
                      bottom: 24.h,
                      color: AppColors.black,
                      textAlign: TextAlign.start,
                    ),

                    // ================ Email TextField ============
                    /// email Field
                    CustomFormCard(
                      title: AppStrings.email,
                      hintText: "Enter your email",
                      hasBackgroundColor: true,
                      controller: forgotPasswordController.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                ///============ verificationEmail Button ============
                Obx(() {
                  String email = forgotPasswordController.emailController.text;
                  return CustomButton(
                    onTap: () async {
                      if (email.isNotEmpty) {
                        final success = await forgotPasswordController
                            .submitForgotPassword();
                        if (success) {
                          Get.to(
                            () => OtpVerifyScreen(
                              forgotPassword: true,
                              email: email,
                            ),
                          );
                        }
                      }
                    },
                    title: forgotPasswordController.isSubmitting.value
                        ? "Sending..."
                        : "Send Verification Code",
                    height: 50.h,
                    fontSize: 18,
                    fillColor: forgotPasswordController.isSubmitting.value
                        ? AppColors.grey_1
                        : AppColors.appColors,
                    borderRadius: 24,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

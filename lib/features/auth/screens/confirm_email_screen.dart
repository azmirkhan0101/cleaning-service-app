import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/screens/otp_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  String? email;

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leftIcon: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.1,
            child: Obx(() {
              authController.newTextEditingController.value;
              return Column(
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
                    fontSize: 12,
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
                        controller: TextEditingController(),
                        // controller: authController.loginEmailController,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  ///============ verificationEmail Button ============
                  CustomButton(
                    onTap: () {
                      Get.to(() => OtpVerifyScreen(forgotPassword: true));
                    },
                    title: "Send Verification Code",
                    height: 50.h,
                    fontSize: 14.sp,
                    fillColor: AppColors.appColors,
                    borderRadius: 24,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

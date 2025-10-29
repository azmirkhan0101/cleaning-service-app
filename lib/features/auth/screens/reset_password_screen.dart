import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordTEController = TextEditingController();
  final confirmPasswordTEController = TextEditingController();

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
                    text: 'Reset Password !',
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
                      140.h.heightBox,

                      /// password Field
                      CustomFormCard(
                        titleColor: Colors.black,
                        title: AppStrings.password,
                        hintText: AppStrings.enterYourPassword,
                        isPassword: true,
                        controller: passwordTEController,
                      ),

                      24.h.heightBox,

                      /// password Field
                      CustomFormCard(
                        titleColor: Colors.black,
                        title: "Confirm Password",
                        hintText: AppStrings.enterYourPassword,
                        isPassword: true,
                        controller: confirmPasswordTEController,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  ///============ verificationEmail Button ============
                  CustomButton(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    title: "Update Password",
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

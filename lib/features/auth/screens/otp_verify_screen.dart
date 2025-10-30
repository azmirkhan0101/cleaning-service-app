import 'package:cleaning_service_app/core/components/custom-buttons/custom_submit_button.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key, this.forgotPassword});
  final bool? forgotPassword;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String? email;

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leftIcon: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.1,
            child: Obx(() {
              authController.newTextEditingController.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Verify Account',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.poppins,
                  ),

                  SizedBox(height: 2.h),

                  CustomText(
                    text: 'Welcome back',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.poppins,
                  ),

                  SizedBox(height: 160.h),

                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [

                  // =========== Enter the code Text ============
                  Center(
                    child: CustomText(
                      text: AppStrings.enterCode,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.lexend,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  /// =========== Enter the code description Text ============
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0),
                      child: CustomText(
                        text: AppStrings.enterTheCodeTitle,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4F4F59),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  ///CustomPinCode(controller: authController.otpController.value),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: PinCodeTextField(
                      textStyle: TextStyle(
                        color: AppColors.lightBlue,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      keyboardType: TextInputType.number,
                      appContext: context,
                      length: 6,
                      enableActiveFill: true,
                      animationType: AnimationType.fade,
                      animationDuration: Duration(milliseconds: 300),
                      controller: TextEditingController(),
                      mainAxisAlignment: MainAxisAlignment.center,
                      cursorColor: AppColors.lightBlue,
                      backgroundColor: Colors.transparent,
                      enablePinAutofill: false,
                      showCursor: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5.r),
                        borderWidth: 0,
                        activeBorderWidth: 0,
                        inactiveBorderWidth: 0,
                        selectedBorderWidth: 0,
                        errorBorderWidth: 0,
                        disabledBorderWidth: 0,
                        fieldHeight: 54.h,
                        fieldWidth: 41.w,
                        fieldOuterPadding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                        ),
                        inactiveColor: Color(0xFFE9EBF3),
                        activeColor: Color(0xFFE9EBF3),
                        activeFillColor: Color(0xFFE9EBF3),
                        inactiveFillColor: Color(0xFFE9EBF3),
                        selectedFillColor: Color(0xFFE9EBF3),
                        disabledColor: Color(0xFFE9EBF3),
                        selectedColor: Color(0xFFE9EBF3),
                        errorBorderColor: Color(0xFFE9EBF3),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      CustomText(
                        text: AppStrings.ididntFind,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      GestureDetector(
                        onTap: () {
                          /// authController.otpResetValidation(email.toString());
                        },
                        child: CustomText(
                          text: AppStrings.sendAgain,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ],
                  ),

                  //   ],
                  // ),
                  SizedBox(height: 133.h),

                  ///============ verificationEmail Button ============
                  CustomSubmitButton(
                    title: AppStrings.verifyCode,
                    onPressed: () {
                      // Handle email verification
                    },
                    isLoading: false,
                  ),
                  // CustomButton(
                  //   onTap: () {
                  //     if (widget.forgotPassword == true) {
                  //       Get.to(() => ResetPasswordScreen());
                  //     } else {
                  //       Get.offNamed(AppRoutes.selectionScreen);
                  //     }
                  //   },
                  //   title: AppStrings.sendCode,
                  //   height: 50.h,
                  //   fontSize: 14.sp,
                  //   fillColor: AppColors.appColors,
                  //   borderRadius: 24,
                  // ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

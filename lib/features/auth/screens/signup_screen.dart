import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  44.h.heightBox,
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
                      // SizedBox(width: 6),
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

                  SizedBox(height: 56.h),

                  /// name Field
                  CustomFormCard(
                    title: AppStrings.yourFirstName,
                    hintText: AppStrings.enterYourName,
                    hasBackgroundColor: true,
                    keyboardType: TextInputType.name,
                    controller: authController.signupNameController.value,
                  ),

                  SizedBox(height: 12),

                  /// phoneNumber Field
                  CustomFormCard(
                    title: AppStrings.phoneNumber,
                    hintText: AppStrings.enterYourPhone,
                    hasBackgroundColor: true,
                    keyboardType: TextInputType.phone,
                    controller: authController.signupPhoneController.value,
                  ),

                  SizedBox(height: 12),

                  /// email Field
                  CustomFormCard(
                    title: AppStrings.email,
                    hintText: AppStrings.enterYourEmail,
                    hasBackgroundColor: true,
                    keyboardType: TextInputType.emailAddress,
                    controller: authController.signupEmailController.value,
                  ),

                  SizedBox(height: 12),

                  /// password Field
                  CustomFormCard(
                    titleColor: Colors.black,
                    title: AppStrings.password,
                    hintText: AppStrings.enterYourPassword,
                    isPassword: true,
                    controller: authController.signupPasswordController.value,
                  ),

                  SizedBox(height: 12),

                  /// confirm password Field
                  CustomFormCard(
                    titleColor: Colors.black,
                    title: AppStrings.comfirmpassword,
                    hintText: AppStrings.enterYourPassword,
                    isPassword: true,
                    controller:
                        authController.signupConfirmPasswordController.value,
                  ),

                  SizedBox(height: 12),

                  /// referral code Field
                  CustomFormCard(
                    titleColor: Colors.black,
                    title: AppStrings.referralCode,
                    hintText: AppStrings.enterReferralCode,
                    controller: authController.signupReferralController.value,
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Checkbox(
                        value: authController.rememberPassword.value,
                        onChanged: (value) {
                          authController.rememberPassword.value = value!;
                        },
                        checkColor: AppColors.black_04,
                        activeColor: AppColors.lightBlue,
                        fillColor: MaterialStateProperty.all(
                          AppColors.lightBlue.withOpacity(0.5),
                        ),
                      ),

                      Text.rich(
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        TextSpan(
                          text:
                              'I agree with terms of conditions and privacy policy',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            /*  TextSpan(
                                      text: ' terms',
                                      style: GoogleFonts.lexend(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.lightBlue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' of service and \n',
                                      style: GoogleFonts.lexend(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black_04,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: GoogleFonts.lexend(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.lightBlue,
                                      ),
                                    ),*/
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      Get.offNamed(AppRoutes.singupOtpScreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.9,
                        50,
                      ), // 90% of screen width
                    ),
                    child: CustomText2(
                      text: AppStrings.signUp,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Or Divider
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: const Color(0xFF0F0B18),
                        ),
                      ),
                      CustomText(
                        text: 'or continue with',
                        color: const Color(0xFF0F0B18),
                        fontSize: 14,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: const Color(0xFF0F0B18),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Social Buttons
                  Row(
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

                      // SizedBox(width: 24),

                      // GestureDetector(
                      //   onTap: () async {},
                      //   child: Container(
                      //     padding: const EdgeInsets.all(12),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(12),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Color(0x26000000),
                      //           blurRadius: 4,
                      //           offset: Offset(0, 0),
                      //           spreadRadius: 0,
                      //         ),
                      //       ],
                      //     ),
                      //     child: Icon(Icons.apple, color: Colors.black, size: 24),
                      //   ),
                      // ),
                      //  SocialIconButton(icon: Icons.apple),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Signup Link
                  GestureDetector(
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
                        CustomText(
                          text: "Sign In",
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightBlue,
                          fontSize: 14,
                          fontFamily: 'Lexend',
                          height: 1.50,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

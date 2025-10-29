import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/screens/confirm_email_screen.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/common/widgets/custom_form_field.dart';
import 'package:cleaning_service_app/features/main-layout/screens/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    // print("Token: ${authController.loginResponse.value?.token}");
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: 'Login Account',
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

                _buildEmailPasswordForm(authController),

                _buildRememberMeAndForgotPassword(),

                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () => _onPressedLogin(authController),

                  // onPressed: () {
                  //   showDialog(
                  //     context: context,
                  //     builder: (ctx) => AlertDialog(
                  //       backgroundColor: Colors.white,
                  //       insetPadding: EdgeInsets.all(8),
                  //       contentPadding: EdgeInsets.all(8),
                  //       title: SizedBox(),
                  //       content: SizedBox(
                  //         width: MediaQuery.sizeOf(context).width,
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Row(
                  //             mainAxisSize: MainAxisSize.min,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               CustomButton(
                  //                 onTap: () {
                  //                   // Get.offAllNamed(AppRoutes.providerHome);
                  //                   Get.offAll(
                  //                     () => MainLayout(isOwner: false),
                  //                   );
                  //                 },
                  //                 title: "provider",
                  //                 height: 45,
                  //                 width: 100,
                  //                 fontSize: 12,
                  //                 fillColor: AppColors.appColors,
                  //               ),

                  //               SizedBox(width: 12),

                  //               CustomButton(
                  //                 onTap: () {
                  //                   // Get.offAllNamed(AppRoutes.ownerHomeScreen);
                  //                   Get.offAll(() => MainLayout(isOwner: true));

                  //                   ///Navigator.of(context).pop();
                  //                 },
                  //                 title: "owner",
                  //                 height: 45,
                  //                 width: 100,
                  //                 fontSize: 12,
                  //                 fillColor: AppColors.appColors,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // },
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
                    text: 'Login',
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
                      text: 'or sign in with',
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

                SizedBox(height: 24.h),

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
                    //       border: Border.all(color: Colors.grey.shade300),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: CircleAvatar(
                    //       backgroundColor: Colors.grey.shade200,
                    //       radius: 20,
                    //       child: Icon(
                    //         Icons.apple,
                    //         color: Colors.black,
                    //         size: 24,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //  SocialIconButton(icon: Icons.apple),
                  ],
                ),

                SizedBox(height: 40),

                // Signup Link
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.signupScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText2(
                        text: "Don't have an account? ",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),

                      SizedBox(width: 6),

                      CustomText2(
                        text: "Sign Up",
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightBlue,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmailPasswordForm(AuthController controller) {
    return Obx(
      () => Form(
        key: controller.loginFormKey,
        autovalidateMode: controller.autovalidateMode.value,
        child: Column(
          children: [
            ///--> Email Field <--///
            CustomFormField(
              controller: controller.loginEmailController,
              hintText: "Enter Email",
              labelText: AppStrings.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // Improved email regex for better validation
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 20),

            ///--> Password Field <--///
            CustomFormField(
              controller: controller.loginPasswordController,
              hintText: "Enter Password",
              labelText: AppStrings.password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
            ),
          ],
        ),
      ),
    );
  }

  Row _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: authController.rememberPassword.value,
              onChanged: (value) {
                authController.rememberPassword.value = value!;
              },
              checkColor: AppColors.black_04, // Color of the check mark
              activeColor:
                  AppColors.lightBlue, // Color of the checkbox when selected
              fillColor: WidgetStatePropertyAll(
                AppColors.lightBlue.withValues(alpha: 0.5),
              ), // Background color when not selected
            ),

            CustomText2(
              text: 'Remember me',
              color: AppColors.lightBlue,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Get.to(() => ConfirmEmailScreen());
          },
          child: CustomText2(
            text: 'Forgot Password?',
            color: AppColors.lightBlue,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Future<void> _onPressedLogin(AuthController controller) async {
    try {
      final success = await controller.login();
      if (success) {
        // Navigate based on user role
        if (controller.loginResponse.value?.userData.role == Role.owner) {
          Get.offAll(() => MainLayout(isOwner: true));
        } else {
          Get.offAll(() => MainLayout(isOwner: false));
        }
      }
    } catch (e) {
      // Handle any errors that occur during login
      debugPrint('Login error: $e');
      // Optionally, show a user-friendly message
      Get.snackbar(
        'Login Failed',
        'An error occurred during login. Please try again.',
      );
    }
  }
}

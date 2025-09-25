import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/features/auth/auth_controller.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final authController = Get.put(AuthController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                 Row(
                   children: [
                     CustomText(text: 'Login Account',fontSize: 24,fontWeight: FontWeight.w600,),
                     SizedBox(width: 6,),
                     Icon(Icons.person_2)
                   ],
                 ),

                  SizedBox(height: 8,),
                  CustomText(
                    text: 'Welcome back',
                    fontSize: 12,fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: 40),

                  /// email Field
                  CustomFormCard(
                    title: AppStrings.email,
                    hintText: AppStrings.enterYourEmail,
                    hasBackgroundColor: true,
                    controller: authController.loginEmailController.value
                  ),


                  SizedBox(height: 20),

                  /// password Field
                  CustomFormCard(
                    titleColor: Colors.black,
                    title: AppStrings.password,
                    hintText: AppStrings.enterYourPassword,
                    hasBackgroundColor: true,
                    isPassword: true,
                    controller:authController.loginPasswordController.value
                  ),


                  SizedBox(height: 12),

                  Row(
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
                            activeColor: AppColors.lightBlue, // Color of the checkbox when selected
                           fillColor: MaterialStateProperty.all(AppColors.lightBlue.withOpacity(0.5)), // Background color when not selected
                          ),

                          CustomText(text: 'Remember me',color: AppColors.lightBlue,fontWeight: FontWeight.w400,fontSize: 14),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: CustomText(text: 'Forgot Password?',color: AppColors.lightBlue,fontWeight: FontWeight.w400,fontSize: 14,),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                 ElevatedButton(
                  onPressed: () {

                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.white,
                        insetPadding: EdgeInsets.all(8),
                        contentPadding: EdgeInsets.all(8),
                        title: SizedBox(),
                        content: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                CustomButton(
                                    onTap: () {

                                      Get.offAllNamed(AppRoutes.providerHome);
                                    },
                                    title: "provider",
                                    height: 45,
                                    width: 100,
                                    fontSize: 12,
                                    fillColor: AppColors.appColors),

                                SizedBox(
                                  width: 12,
                                ),

                                CustomButton(
                                  onTap: () {

                                    Get.offAllNamed(AppRoutes.ownerHomeScreen);

                                 ///Navigator.of(context).pop();
                                  },
                                  title: "owner",
                                  height: 45,
                                  width: 100,
                                  fontSize: 12,
                                  fillColor: AppColors.appColors,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColors,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),  // 90% of screen width
                  ),
                  child: CustomText(
                    text: 'Login',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                  const SizedBox(height: 16),

                  // Or Divider
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:  [
                        SizedBox(
                            width: 100,
                            child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: CustomText(text: 'or sign in with',fontWeight: FontWeight.w400,fontSize: 14,),
                        ),
                        SizedBox(
                            width: 150,
                            child: Divider(thickness: 1)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [

                      GestureDetector(
                        onTap: ()  {

                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              radius: 20,
                              child: CustomImage(imageSrc: AppImages.googleImage,width: 24,height: 24,)

                          ),
                        ),
                      ),


                      SizedBox(
                        width: 24,
                      ),

                      GestureDetector(
                        onTap: ()async{

                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            radius: 20,
                            child: Icon(
                              Icons.apple,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      //  SocialIconButton(icon: Icons.apple),
                    ],
                  ),

                  SizedBox(height: 40),

                  // Signup Link
                  GestureDetector(
                    onTap: (){

                     Get.toNamed(AppRoutes.signupScreen);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:   [

                        CustomText(text: "Don't have an account? ",fontSize: 14,fontWeight: FontWeight.w400,),

                        SizedBox(
                          width: 6,
                        ),
                        CustomText(text:
                          "Sign Up",
                         fontWeight:  FontWeight.w600, color: AppColors.lightBlue),

                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

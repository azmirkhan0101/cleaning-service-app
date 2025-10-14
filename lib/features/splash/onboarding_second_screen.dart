import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingSecondScreen extends StatefulWidget {
  const OnboardingSecondScreen({super.key});

  @override
  State<OnboardingSecondScreen> createState() => _OnboardingSecondScreenState();
}

class _OnboardingSecondScreenState extends State<OnboardingSecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          ///Background
          Container(
            color: AppColors.lightBlue, // blue background
            height: double.infinity,
            width: double.infinity,
          ),

          Positioned(
            top: 60,
            child: CustomImage(
              imageSrc: AppImages.onboarding2,
              fit: BoxFit.fill,
              width: MediaQuery.of(
                context,
              ).size.width, // Use full width of screen
              height:
                  MediaQuery.of(context).size.height *
                  0.48, // Adjust height proportionally
            ),
          ),

          // Main content wrapped in SingleChildScrollView
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white_50, // Set the background color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      30,
                    ), // Set the top-left corner radius
                    topRight: Radius.circular(
                      30,
                    ), // Set the top-right corner radius
                  ),
                ),
                height:
                    MediaQuery.of(context).size.height /
                    2.2, // Adjust height based on screen size
                width: double.infinity, // Full width of the screen
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ), // Adjust padding for responsiveness
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),

                        // Heading text
                        CustomText2(
                          text: 'Solutions to make your life easy!',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16),

                        CustomText2(
                          text:
                              'Find the perfect Service for your home, fast and worry-free',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 24),

                        // "Get Started" Button
                        ElevatedButton(
                          onPressed: () {
                            Get.offNamed(AppRoutes.loginScreen);
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
                            text: 'Get Started',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 24),

                        // "Already have an account" Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.lightBlue,
                              width: 1,
                            ), // Border color and width
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Rounded corners
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ), // Padding
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.9,
                              50,
                            ), // 90% of screen width
                          ),
                          onPressed: () {
                            // Handle button press
                            Get.offNamed(AppRoutes.signupScreen);
                          },
                          child: CustomText2(
                            text: 'Already have an account',
                            color: AppColors.lightBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

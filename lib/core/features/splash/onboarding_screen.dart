import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboardingscreen extends StatefulWidget {

  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body:Stack(
        children: [

          // Background
          Container(
            color: AppColors.lightBlue,  // blue background
            height: double.infinity,
            width: double.infinity,
          ),

          ///Main content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                CustomImage(
                  imageSrc: AppImages.onboarding,
                  fit:BoxFit.fill,
                  width: 350,
                ),

                const SizedBox(height: 30),

                // Heading text
                CustomText(text:
                'Professional Real Estate Services, Anytime',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 8),

                //Subheading text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,
                  ),
                  child: CustomText(
                    text:  'Book trusted professionals in minutes. From home maintenance to repairing and more, we provide a variety of service for your property.',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    color: Colors.white,
                    maxLines: 3,
                  ),
                ),

                const  SizedBox(height: 40),

                InkWell(
                  onTap: (){
                    Get.offNamed(AppRoutes.onboardingSecondScreen);
                  },
                  child: CustomImage(
                    imageSrc: AppIcons.startIcons,
                    fit:BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

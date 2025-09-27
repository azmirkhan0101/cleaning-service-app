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

          CustomImage(
              imageSrc: AppImages.banner_im2),

          Positioned(
            bottom: 64,
            child: InkWell(
              onTap: (){
                Get.offNamed(AppRoutes.onboardingSecondScreen);
              },
              child: CustomImage(
                imageSrc: AppIcons.startIcons,
                fit:BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

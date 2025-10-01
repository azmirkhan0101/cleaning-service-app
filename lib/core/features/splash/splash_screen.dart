
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/features/splash/onboarding_controller.dart';
import 'package:cleaning_service_app/core/helper/shared_prefe/shared_prefe.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  final onboardingController = Get.put(OnboardingController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      Future.delayed(const Duration(seconds: 6), () async{

        onboardingController.checkAndRequestPermissions();

        var token = await SharePrefsHelper.getString(AppConstants.bearerToken);

        if(token.isNotEmpty){

          ///Get.offAllNamed(AppRoutes.homeScreen);

        }else{

          Get.offAllNamed(AppRoutes.onboardingScreen);
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            CustomImage(
                imageSrc: AppImages.banner_image),
          ],
        ),
      ),
    );
  }
}

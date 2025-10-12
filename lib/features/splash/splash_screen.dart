import 'package:cleaning_service_app/features/splash/get_started_screen.dart';
import 'package:cleaning_service_app/features/splash/onboarding_controller.dart';
import 'package:cleaning_service_app/core/helper/shared_prefe/shared_prefe.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final onboardingController = Get.put(OnboardingController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () async {
        onboardingController.checkAndRequestPermissions();

        var token = await SharePrefsHelper.getString(AppConstants.bearerToken);

        if (token.isNotEmpty) {
          ///Get.offAllNamed(AppRoutes.homeScreen);
        } else {
          // Get.offAllNamed(AppRoutes.onboardingScreen);
          Get.offAll(() => GetStartedScreen());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboarding-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/app-logo.png",
                  width: 200,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 32,
                  child: Text(
                    'Tap. Match. Done.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF4899D1),
                      fontSize: 18,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

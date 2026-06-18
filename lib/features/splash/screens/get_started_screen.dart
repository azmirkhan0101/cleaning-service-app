import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/utils/context_extension/context_extension.dart';
import 'package:cleaning_service_app/features/auth/screens/login_screen.dart';
import 'package:cleaning_service_app/features/splash/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final onboardingController = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

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
        child: Padding(
          padding: EdgeInsets.only(right: size.width * 0.35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),
              Image.asset(
                "assets/images/app-logo.png",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              // The right solution on the right time
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  'THE RIGHT SOLUTION, ON THE RIGHT TIME',
                  style: TextStyle(
                    color: const Color(0xFF1B2D51),
                    fontSize: 28,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),
              // image
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Image.asset(
                  "assets/images/onboarding-image.jpg",
                  // width: size.width * 0.5,
                  // height: size.height * 0.5,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // divider
              Center(
                child: Divider(
                  color: Color(0xFF1B2D51),
                  thickness: 1,
                  indent: 40,
                ),
              ),
              Padding(
                // width: 153,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Book your service in minutes, and solve problem at your property',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF1B2D51),
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FilledButton(
          onPressed: _onClickGetStarted,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            fixedSize: Size(double.maxFinite, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                'Get Started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  Color(0xFFF7A51D),
                  fontSize: isTab ? 10.sp : 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
              Assets.icons.arrowNarrowRight.svg(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFF7A51D),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomSheet: _buildBottomSheet(),
    );
  }

  // OnClick function for Get Started button
  void _onClickGetStarted() {
    Get.to(() => LoginScreen());
  }
}

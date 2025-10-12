import 'package:cleaning_service_app/features/auth/login_screen.dart';
import 'package:cleaning_service_app/features/splash/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      floatingActionButton: FilledButton(
        onPressed: _onclickGetStarted,
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
                color: const Color(0xFFF7A51D),
                fontSize: 16,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            SvgPicture.asset(
              'assets/icons/arrow-narrow-right.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      width: double.infinity,
      height: 247,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 34),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFF4899D1)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title text
          Text(
            'Solutions to make your life easy!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0F0B18),
              fontSize: 24,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              height: 1.40,
              letterSpacing: -0.50,
            ),
          ),
          SizedBox(height: 10),

          // Description text
          Text(
            'Find the perfect Service for your home, fast and worry-free',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4F4F59),
              fontSize: 16,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 24),

          // Get Started button
          FilledButton(
            onPressed: _onclickGetStarted,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF7A51D),
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
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/arrow-narrow-right.svg',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Onclick function for Get Started button
  void _onclickGetStarted() {
    Get.to(() => LoginScreen());
  }
}

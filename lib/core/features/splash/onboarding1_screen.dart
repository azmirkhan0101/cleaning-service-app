import 'package:cleaning_service_app/core/features/splash/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding1Screen extends StatefulWidget {
  const Onboarding1Screen({super.key});

  @override
  State<Onboarding1Screen> createState() => _Onboarding1ScreenState();
}

class _Onboarding1ScreenState extends State<Onboarding1Screen> {
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
      // Put this into your Scaffold:
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFC04A), // light
              Color(0xFFFF9B2E), // darker
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: RawMaterialButton(
          onPressed: () {
            // TODO: onPressed action
          },
          elevation: 0,
          shape: CircleBorder(),
          child: Icon(Icons.arrow_forward, color: Colors.white, size: 28),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

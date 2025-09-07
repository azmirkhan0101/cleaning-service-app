
import 'package:cleaning_service_app/core/features/auth/login_screen.dart';
import 'package:cleaning_service_app/core/features/auth/signup/signup_screen.dart';
import 'package:cleaning_service_app/core/features/auth/signup/singup_otp_screen.dart';
import 'package:cleaning_service_app/core/features/selection/selection_screen.dart';
import 'package:cleaning_service_app/core/features/splash/onboarding_screen.dart';
import 'package:cleaning_service_app/core/features/splash/onboarding_second_screen.dart';
import 'package:cleaning_service_app/core/features/splash/splash_screen.dart';
import 'package:get/get.dart';



///=========================App Routes=========================
class AppRoutes {
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/Onboardingscreen";
  static const String onboardingSecondScreen = "/OnboardingSecondScreen";
  static const String loginScreen = "/LoginScreen";
  static const String signupScreen = "/SignupScreen";
  static const String singupOtpScreen = "/SingupOtpScreen";
  static const String selectionScreen = "/SelectionScreen";



  static List<GetPage> routes = [

    ///===========================Authentication==========================

   GetPage(name: splashScreen, page: () => SplashScreen()),

   GetPage(name: onboardingScreen, page: () => Onboardingscreen()),
    
   GetPage(name: onboardingSecondScreen, page: () => OnboardingSecondScreen()),

   GetPage(name: loginScreen, page: () => LoginScreen()),

   GetPage(name: signupScreen, page: () => SignupScreen()),

   GetPage(name: singupOtpScreen, page: () => SingupOtpScreen()),

   GetPage(name: selectionScreen, page: () => SelectionScreen()),


  ];

}

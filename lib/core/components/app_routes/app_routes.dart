
import 'package:cleaning_service_app/core/features/auth/login_screen.dart';
import 'package:cleaning_service_app/core/features/auth/signup/signup_screen.dart';
import 'package:cleaning_service_app/core/features/auth/signup/singup_otp_screen.dart';
import 'package:cleaning_service_app/core/features/bookings/bookings_screen.dart';
import 'package:cleaning_service_app/core/features/bookings/qr_scanner_screen.dart';
import 'package:cleaning_service_app/core/features/bookings/service_details_screen.dart';
import 'package:cleaning_service_app/core/features/location/map_picker.dart';
import 'package:cleaning_service_app/core/features/notification/notification_screen.dart';
import 'package:cleaning_service_app/core/features/location/location_screen.dart';
import 'package:cleaning_service_app/core/features/payment/payment_screen.dart';
import 'package:cleaning_service_app/core/features/provider/provider_home.dart';
import 'package:cleaning_service_app/core/features/selection/selection_screen.dart';
import 'package:cleaning_service_app/core/features/service/edit_service_screen.dart';
import 'package:cleaning_service_app/core/features/service/service_add_screen.dart';
import 'package:cleaning_service_app/core/features/service/service_details.dart';
import 'package:cleaning_service_app/core/features/service/work_schedule_screen.dart';
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
  static const String paymentScreen = "/PaymentScreen";
  static const String providerHome = "/ProviderHome";
  static const String serviceDetailsScreen = "/ServiceDetailsScreen";
  static const String bookingsScreen = "/BookingsScreen";
  static const String qrScannerScreen = "/QrScannerScreen";
  static const String locationScreen = "/LocationScreen";
  static const String pickerMapScreen = "/PickerMapScreen";
  static const String notificationScreen = "/NotificationScreen";
  static const String serviceDetails = "/ServiceDetails";
  static const String editServiceScreen = "/EditServiceScreen";
  static const String workScheduleScreen = "/WorkScheduleScreen";
  static const String serviceAddScreen = "/ServiceAddScreen";




  static List<GetPage> routes = [

    ///===========================Authentication==========================

   GetPage(name: splashScreen, page: () => SplashScreen()),

   GetPage(name: onboardingScreen, page: () => Onboardingscreen()),
    
   GetPage(name: onboardingSecondScreen, page: () => OnboardingSecondScreen()),

   GetPage(name: loginScreen, page: () => LoginScreen()),

   GetPage(name: signupScreen, page: () => SignupScreen()),

   GetPage(name: singupOtpScreen, page: () => SingupOtpScreen()),

   GetPage(name: selectionScreen, page: () => SelectionScreen()),

   GetPage(name: paymentScreen, page: () => PaymentScreen()),

   GetPage(name: providerHome, page: () => ProviderHome()),

   GetPage(name: serviceDetailsScreen, page: () => ServiceDetailsScreen()),

   GetPage(name: bookingsScreen, page: () => BookingsScreen()),

   GetPage(name: qrScannerScreen, page: () => QrScannerScreen()),

   GetPage(name: locationScreen, page: () => LocationScreen()),

   GetPage(name: pickerMapScreen, page: () => PickerMapScreen()),

   GetPage(name: notificationScreen, page: () => NotificationScreen()),

   GetPage(name: serviceDetails, page: () => ServiceDetails()),

   GetPage(name: editServiceScreen, page: () => EditServiceScreen()),

   GetPage(name: workScheduleScreen, page: () => WorkScheduleScreen()),

   GetPage(name: serviceAddScreen, page: () => ServiceAddScreen()),


  ];

}

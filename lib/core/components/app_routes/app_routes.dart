import 'package:cleaning_service_app/features/auth/screens/login_screen.dart';
import 'package:cleaning_service_app/features/auth/screens/otp_verify_screen.dart';
import 'package:cleaning_service_app/features/auth/screens/selection_screen.dart';
import 'package:cleaning_service_app/features/auth/screens/signup_screen.dart';
import 'package:cleaning_service_app/features/location/location_screen.dart';
import 'package:cleaning_service_app/features/location/map_picker.dart';
import 'package:cleaning_service_app/features/notification/notification_screen.dart';
import 'package:cleaning_service_app/features/owner/booking/owner_scanner_screen.dart';
import 'package:cleaning_service_app/features/owner/education/home/bribk_opportunities_screen.dart';
import 'package:cleaning_service_app/features/owner/education/home/education_home_screen.dart';
import 'package:cleaning_service_app/features/owner/education/home/education_training_screen.dart';
import 'package:cleaning_service_app/features/owner/education/home/industry_trends_screen.dart';
import 'package:cleaning_service_app/features/owner/education/home/legal_regulatory_screen.dart';
import 'package:cleaning_service_app/features/owner/home/owner_home_screen.dart';
import 'package:cleaning_service_app/features/owner/home/owner_search_screen.dart';
import 'package:cleaning_service_app/features/owner/inbox/owner_inbox_screen.dart';
import 'package:cleaning_service_app/features/owner/inbox/owner_message_screen.dart';
import 'package:cleaning_service_app/features/owner/profile/profile_screen.dart';
import 'package:cleaning_service_app/features/owner/service/screens/owner_category_screen.dart';
import 'package:cleaning_service_app/features/owner/service/screens/owner_services_by_category_screen.dart';
import 'package:cleaning_service_app/features/owner/service/service_book_second_screen.dart';
import 'package:cleaning_service_app/features/owner/service/service_booking.dart';
import 'package:cleaning_service_app/features/payment/payment_screen.dart';
import 'package:cleaning_service_app/features/policy/about_us_screen.dart';
import 'package:cleaning_service_app/features/policy/privacy_policy_screen.dart';
import 'package:cleaning_service_app/features/policy/terms_condition_screen.dart';
import 'package:cleaning_service_app/features/provider/bookings/bookings_screen.dart';
import 'package:cleaning_service_app/features/provider/bookings/qr_scanner_screen.dart';
import 'package:cleaning_service_app/features/provider/bookings/service_details_screen.dart';
import 'package:cleaning_service_app/features/provider/inbox/inbox_screen.dart';
import 'package:cleaning_service_app/features/provider/pro_plan_subscription/pro_plan_subscription_screen.dart';
import 'package:cleaning_service_app/features/provider/profile/boost_payment_screen.dart';
import 'package:cleaning_service_app/features/provider/profile/change_password.dart';
import 'package:cleaning_service_app/features/provider/profile/earning_screen.dart';
import 'package:cleaning_service_app/features/provider/profile/profile_edit_screen.dart';
import 'package:cleaning_service_app/features/provider/profile/profile_screen.dart';
import 'package:cleaning_service_app/features/provider/profile/refer_screen.dart';
import 'package:cleaning_service_app/features/provider/provider_home.dart';
import 'package:cleaning_service_app/features/provider/service/edit_service_screen.dart';
import 'package:cleaning_service_app/features/provider/service/review_screen.dart';
import 'package:cleaning_service_app/features/provider/service/service_add_screen.dart';
import 'package:cleaning_service_app/features/provider/service/service_details.dart';
import 'package:cleaning_service_app/features/provider/service/work_schedule_screen.dart';
import 'package:cleaning_service_app/features/services/screens/owner_service_details_screen.dart';
import 'package:cleaning_service_app/features/splash/screens/splash_screen.dart';
import 'package:get/get.dart';

///=========================App Routes=========================
class AppRoutes {
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/Onboardingscreen";
  static const String onboardingSecondScreen = "/OnboardingSecondScreen";
  static const String loginScreen = "/LoginScreen";
  static const String signupScreen = "/SignupScreen";
  static const String singUpOtpScreen = "/SingupOtpScreen";
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
  static const String messageScreen = "/MessageScreen";
  static const String profileScreen = "/ProfileScreen";
  static const String boostPaymentScreen = "/BoostPaymentScreen";
  static const String editPersonProfileScreen = "/EditPersonProfileScreen";
  static const String myEarningScreen = "/MyEarningScreen";
  static const String changePasswordScreen = "/ChangePasswordScreen";
  static const String referScreen = "/ReferScreen";
  static const String aboutUsScreen = "/AboutUsScreen";
  static const String privacyPolicyScreen = "/PrivacyPolicyScreen";

  static const String termsConditionScreen = "/termsConditionScreen";

  static const String providerInboxScreen = "/ProviderInboxScreen";

  static const String proPlanSubscriptionScreen = "/ProPlanSubscriptionScreen";

  static const String reviewScreen = "/ReviewScreen";

  static const String ownerHomeScreen = "/OwnerHomeScreen";

  static const String ownerCategoryByService = "/OwnerCategoryByService";

  static const String ownerServiceDetailsScreen = "/OwnerServiceDetailsScreen";

  static const String serviceBooking = "/ServiceBooking";

  static const String serviceBookSecondScreen = "/ServiceBookSecondScreen";

  static const String ownerCategoryScreen = "/OwnerCategoryScreen";

  static const String ownerScannerScreen = "/OwnerScannerScreen";

  static const String ownerInboxScreen = "/OwnerInboxScreen";

  static const String ownerMessageScreen = "/OwnerMessageScreen";

  static const String ownerProfileScreen = "/OwnerProfileScreen";

  static const String educationHomeScreen = "/EducationHomeScreen";

  static const String legalRegulatoryScreen = "/LegalRegulatoryScreen";

  static const String industryTrendsScreen = "/IndustryTrendsScreen";

  static const String bribkOpportunitiesScreen = "/BribkOpportunitiesScreen";

  static const String educationTrainingScreen = "/EducationTrainingScreen";

  static const String ownerSearchScreen = "/OwnerSearchScreen";

  static List<GetPage> routes = [
    ///===========================Authentication==========================
    GetPage(name: splashScreen, page: () => SplashScreen()),

    // GetPage(name: onboardingScreen, page: () => Onboarding2Screen()),

    // GetPage(name: onboardingSecondScreen, page: () => OnboardingSecondScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),

    GetPage(name: signupScreen, page: () => SignupScreen()),

    GetPage(name: singUpOtpScreen, page: () => OtpVerifyScreen()),

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

    GetPage(name: messageScreen, page: () => OwnerMessageScreen()),

    GetPage(name: profileScreen, page: () => ProfileScreen()),

    GetPage(name: boostPaymentScreen, page: () => BoostPaymentScreen()),

    GetPage(
      name: editPersonProfileScreen,
      page: () => EditPersonProfileScreen(),
    ),

    GetPage(name: myEarningScreen, page: () => MyEarningScreen()),

    GetPage(name: changePasswordScreen, page: () => ChangePasswordScreen()),

    GetPage(name: referScreen, page: () => ReferScreen()),

    GetPage(name: aboutUsScreen, page: () => AboutUsScreen()),

    GetPage(name: privacyPolicyScreen, page: () => PrivacyPolicyScreen()),

    GetPage(name: termsConditionScreen, page: () => TermsConditionScreen()),

    GetPage(name: providerInboxScreen, page: () => ProviderInboxScreen()),

    GetPage(
      name: proPlanSubscriptionScreen,
      page: () => ProPlanSubscriptionScreen(),
    ),

    GetPage(name: reviewScreen, page: () => ReviewScreen()),

    GetPage(name: ownerHomeScreen, page: () => OwnerHomeScreen()),

    GetPage(
      name: ownerCategoryByService,
      page: () => OwnerServicesByCategoryScreen(),
    ),

    GetPage(
      name: ownerServiceDetailsScreen,
      page: () => OwnerServiceDetailsScreen(),
    ),

    GetPage(name: serviceBooking, page: () => ServiceBooking()),

    GetPage(
      name: serviceBookSecondScreen,
      page: () => ServiceBookSecondScreen(),
    ),

    GetPage(name: ownerCategoryScreen, page: () => OwnerCategoryScreen()),

    GetPage(name: ownerScannerScreen, page: () => OwnerScannerScreen()),

    GetPage(name: ownerInboxScreen, page: () => OwnerInboxScreen()),

    GetPage(name: ownerMessageScreen, page: () => OwnerMessageScreen()),

    GetPage(name: ownerProfileScreen, page: () => OwnerProfileScreen()),

    GetPage(name: educationHomeScreen, page: () => EducationHomeScreen()),

    GetPage(name: legalRegulatoryScreen, page: () => LegalRegulatoryScreen()),

    GetPage(name: industryTrendsScreen, page: () => IndustryTrendsScreen()),

    GetPage(
      name: bribkOpportunitiesScreen,
      page: () => BribkOpportunitiesScreen(),
    ),

    GetPage(
      name: educationTrainingScreen,
      page: () => EducationTrainingScreen(),
    ),

    GetPage(name: ownerSearchScreen, page: () => OwnerSearchScreen()),
  ];
}

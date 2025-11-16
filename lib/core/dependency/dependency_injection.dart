import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/auth/controllers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/owner/home/controllers/owner_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/owner_service_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_booking_controller.dart';
import 'package:cleaning_service_app/features/payment/controllers/payment_controller.dart';
import 'package:cleaning_service_app/features/provider/service/service_controller.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    /// ========================== Core Services ==========================
    Get.put(NetworkHelper(), permanent: true);

    /// ========================== Auth Controller ==========================
    Get.put(AuthController(), permanent: true);
    Get.put(ProfileSetupController(), permanent: true);
    // OtpVerifyController is created per-screen to ensure fresh state
    // LoginController and SignupController are created per-screen with tags

    ///==========================Default Custom Controller ==================
    Get.lazyPut(() => SelectionController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    // Get.lazyPut(() => BookingController(), fenix: true);
    Get.lazyPut(() => ServiceController(), fenix: true);
    Get.lazyPut(() => OwnerController(), fenix: true);
    Get.lazyPut(() => OwnerServiceController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
    Get.lazyPut(() => ServiceBookingController(), fenix: true);

    /// === => Owner Booking Controller ===
    Get.lazyPut(() => OwnerBookingController(), fenix: true);
  }
}

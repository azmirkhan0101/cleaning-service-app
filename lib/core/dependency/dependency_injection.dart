import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/owner/home/owner_controller.dart';
import 'package:cleaning_service_app/features/owner/service/owner_service_controller.dart';
import 'package:cleaning_service_app/features/payment/payment_controller.dart';
import 'package:cleaning_service_app/features/provider/bookings/booking_controller.dart';
import 'package:cleaning_service_app/features/provider/service/service_controller.dart';
import 'package:cleaning_service_app/features/auth/selection_controller.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    ///==========================Default Custom Controller ==================
    Get.lazyPut(() => SelectionController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    Get.lazyPut(() => BookingController(), fenix: true);
    Get.lazyPut(() => ServiceController(), fenix: true);
    Get.lazyPut(() => OwnerController(), fenix: true);
    Get.lazyPut(() => OwnerServiceController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
  }
}

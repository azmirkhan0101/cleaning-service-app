
import 'package:cleaning_service_app/core/features/bookings/booking_controller.dart';
import 'package:cleaning_service_app/core/features/owner/home/owner_controller.dart';
import 'package:cleaning_service_app/core/features/payment/payment_controller.dart';
import 'package:cleaning_service_app/core/features/selection/selection_controller.dart';
import 'package:cleaning_service_app/core/features/service/service_controller.dart';
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


  }
}


import 'package:cleaning_service_app/core/features/payment/payment_controller.dart';
import 'package:cleaning_service_app/core/features/selection/selection_controller.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {

  @override
  void dependencies() {

    ///==========================Default Custom Controller ==================
    Get.lazyPut(() => SelectionController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);


  }
}

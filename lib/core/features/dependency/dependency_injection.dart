import 'package:cleaning_service_app/core/features/selection/selection_controller%20.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {

  @override
  void dependencies() {

    ///==========================Default Custom Controller ==================
    Get.lazyPut(() => SelectionController(), fenix: true);


  }
}

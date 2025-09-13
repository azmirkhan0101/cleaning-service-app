import 'package:get/get.dart';

class PaymentController extends GetxController {
  // Define an observable variable to store the selected value
  RxString selectedCountry = ''.obs;

  // You can also initialize the selectedCountry with a default value
  @override
  void onInit() {
    super.onInit();
    selectedCountry.value = 'USA'; // Default selection
  }
}
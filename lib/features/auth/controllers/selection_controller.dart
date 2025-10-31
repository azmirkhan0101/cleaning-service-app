import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionController extends GetxController {
  RxString selectedType = 'Owner'.obs;

  void changeType(String type) {
    selectedType.value = type;
  }

  /// owner or provider type option
  RxBool typeModeStatues = false.obs;

  RxInt currentIndex = 0.obs;

  /// location textfileld
  Rx<TextEditingController> locationController = TextEditingController().obs;

  Rx<TextEditingController> loginEmailController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  /// owner or provider type option
  RxBool typPaymentStatues = false.obs;
}

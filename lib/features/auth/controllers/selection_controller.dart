import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionController extends GetxController {
  Rx<Role> selectedRole = Role.owner.obs;

  void changeType(Role type) {
    selectedRole.value = type;
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

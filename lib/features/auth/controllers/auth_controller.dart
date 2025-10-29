import 'package:cleaning_service_app/features/auth/controllers/login_mixin.dart';
import 'package:cleaning_service_app/features/auth/controllers/signup_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController with SignupMixin, LoginMixin {
  RxBool rememberPassword = false.obs;

  Rx<TextEditingController> newTextEditingController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  @override
  void onClose() {
    // Make sure you dispose of the controller when it's no longer needed
    newTextEditingController.value.dispose();
    super.onClose();
  }

  var selectedTime = Rx<TimeOfDay?>(null);

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }
}
